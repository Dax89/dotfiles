#! /bin/env ruby

require 'json'

def print_entries(entries, selentry, icon, type, index)
  idx = -1

  entries.each do |entry|
    info = {
      type: type,
      id: entry['name'],
      name: entry['description'],
      icon: icon
    }

    channelmap = entry['channel_map'].split(',')
                                     .delete_if(&:empty?)

    volume = if entry['mute']
               '0%'
             else
               maxvol = channelmap.map { |x| entry['volume'][x]['value_percent'].to_i }
                                  .max

               "#{maxvol}%"
             end

    print "#{info[:name]} - #{volume}\0icon\x1f#{icon}\x1finfo\x1f#{info.to_json}"

    if entry['name'] == selentry
      idx = index
      print "\x1fnonselectable\x1ftrue"
    end

    puts
    index += 1
  end

  [idx, index]
end

def show_audio
  sinks = JSON.parse `pactl -f json list sinks`
  sources = JSON.parse `pactl -f json list sources`
  selsink = `pactl get-default-sink`.chomp
  selsource = `pactl get-default-source`.chomp

  sinkres = print_entries sinks, selsink, 'audio-volume-high-symbolic', 'sink', 0
  sourceres = print_entries sources, selsource, 'microphone-sensitivity-high-symbolic', 'source', sinkres[1]
  puts "\0active\x1f#{sinkres[0]},#{sourceres[0]}"
end

choice = ENV['ROFI_RETV']

if choice == '1'
  info = JSON.parse ENV['ROFI_INFO']
  system "pactl set-default-#{info['type']} #{info['id']}"

  if info['type'] == 'sink'
    system "dunstify Output \'#{info['name']}\' -i #{info['icon']} -r 2000 -u low"
  else
    system "dunstify Input \'#{info['name']}\' -i #{info['icon']} -u low -r 2000 "
  end
end

show_audio
