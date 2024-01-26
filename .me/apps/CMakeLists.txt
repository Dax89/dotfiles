cmake_minimum_required(VERSION 3.25)

project(apps)

function(add_app target_name)
    add_executable(${target_name})

    target_compile_options(${target_name}
        PRIVATE
            $<$<CONFIG:Debug>:-fsanitize=address,undefined>
    )

    target_link_libraries(${target_name}
        PRIVATE
            $<$<CONFIG:Debug>:-fsanitize=address,undefined>
            $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
    )
endfunction()

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(GIO REQUIRED gio-2.0)

add_app(filemanagerd)
target_sources(filemanagerd PRIVATE filemanagerd.cpp)

target_include_directories(filemanagerd 
    PRIVATE
        ${GLIB_INCLUDE_DIRS}
        ${GIO_INCLUDE_DIRS}
)

target_link_libraries(filemanagerd
    PRIVATE
        ${GLIB_LIBRARIES}
        ${GIO_LIBRARIES}
)
