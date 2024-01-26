#include <array>
#include <cstdlib>
#include <gio/gio.h>
#include <glib.h>
#include <string_view>
#include <unistd.h>

// https://gitlab.gnome.org/GNOME/glib/-/blob/ee470da7c837d6c7cab5691e0c8fa7b48b2f5737/gio/tests/gdbus-example-server.c

namespace {

constexpr const char* FILEMANAGER_NAME = "org.freedesktop.FileManager1";
constexpr const char* FILEMANAGER_PATH = "/org/freedesktop/FileManager1";

constexpr const char* FILEMANAGER_XML =
    R"(
<node>
<interface name='org.freedesktop.FileManager1'>
    <method name='ShowFolders'>
      <arg type='as' name='URIs' direction='in'/>
      <arg type='s' name='StartupId' direction='in'/>
    </method>
    <method name='ShowItems'>
      <arg type='as' name='URIs' direction='in'/>
      <arg type='s' name='StartupId' direction='in'/>
    </method>
    <method name='ShowItemProperties'>
      <arg type='as' name='URIs' direction='in'/>
      <arg type='s' name='StartupId' direction='in'/>
    </method>
  </interface>
</node>
)";

GDBusNodeInfo* introspection;

void on_method_call(GDBusConnection* /*conn*/, const gchar* /*sender*/,
                    const gchar* /*objpath*/, const gchar* /*ifacename*/,
                    const gchar* methodname, GVariant* parameters,
                    GDBusMethodInvocation* /*invocation*/,
                    gpointer /*userdata*/) {
    GVariantIter* iter = nullptr;
    gchar* startupid = nullptr;
    g_variant_get(parameters, "(ass)", &iter, &startupid);

    GVariant* v = g_variant_iter_next_value(iter);

    if(v) {
        std::string_view filepath = g_variant_get_string(v, nullptr);
        if(!filepath.find("file://"))
            filepath = filepath.substr(7);

        switch(::fork()) {
            case -1:
                g_error("Cannot fork process, error code: %d", errno);
                break;

            case 0: { // Child
                std::array<const char*, 5> args = {
                    "-e", "vifm", nullptr, nullptr, nullptr,
                };

                size_t i = 2;
                std::string_view m{methodname};
                bool select = m == "ShowItems" || m == "ShowItemProperties";
                if(select)
                    args[i++] = "--select";
                args[i] = filepath.data();

                if(::execvp("kitty", const_cast<char**>(args.data())) == -1) {
                    g_error("Cannot execute: '%s', error code: %d",
                            filepath.data(), errno);
                }

                break;
            }

            default: // Parent
                break;
        }

        g_variant_unref(v);
    }

    g_variant_iter_free(iter);
}

const GDBusInterfaceVTable IFACE_VTABLE = {
    on_method_call,
    nullptr,
    nullptr,
    nullptr,
};

void on_bus_acquired(GDBusConnection* conn, const gchar* /*name*/, gpointer) {
    guint regid = g_dbus_connection_register_object(
        conn, FILEMANAGER_PATH, introspection->interfaces[0], &IFACE_VTABLE,
        nullptr, nullptr, nullptr);

    g_assert(regid > 0);
}

void on_name_lost(GDBusConnection* /*conn*/, const gchar* /*name*/, gpointer) {
    std::exit(1);
}

} // namespace

int main() {
    introspection = g_dbus_node_info_new_for_xml(FILEMANAGER_XML, nullptr);

    guint ownerid = g_bus_own_name(
        G_BUS_TYPE_SESSION, FILEMANAGER_NAME, G_BUS_NAME_OWNER_FLAGS_NONE,
        &on_bus_acquired, nullptr, &on_name_lost, nullptr, nullptr);

    GMainLoop* loop = g_main_loop_new(nullptr, false);
    g_main_loop_run(loop);
    g_bus_unown_name(ownerid);
    g_dbus_node_info_unref(introspection);
    return 0;
}
