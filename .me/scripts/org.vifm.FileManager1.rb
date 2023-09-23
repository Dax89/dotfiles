#!/bin/env ruby
# https://www.freedesktop.org/wiki/Specifications/file-manager-interface

require 'dbus'

def open_file_manager(uri, select: false)
  args = ['kitty', 'vifm']
  args.append '--select' if select

  path = uri
  path = path[7..] if path.start_with? 'file://'
  args.append path

  system "#{args.join(' ')}&"
end

class FileManager < DBus::Object
  dbus_interface 'org.freedesktop.FileManager1' do
    dbus_method :ShowFolders, 'in uris:as, in startupId:s' do |uris, _|
      open_file_manager uris.first
    end

    dbus_method :ShowItems, 'in uris:as, in startupId:s' do |uris, _|
      open_file_manager uris.first, select: true
    end

    dbus_method :ShowItemProperties, 'in uris:as, in startupId:s' do |_, _|
      puts 'Not Implemented'
    end
  end
end

bus = DBus.session_bus
service = bus.request_service 'org.freedesktop.FileManager1'
fm = FileManager.new '/org/freedesktop/FileManager1'
service.export fm

loop = DBus::Main.new
loop << bus
loop.run
