#! /bin/env ruby

require 'json'

VOLUME_APP = 'i3-volume'.freeze

def current_sink
  sinks = JSON.parse `pactl -f json list sinks`
  selsink = `pactl get-default-sink`.chomp
  sink = sinks.find { |x| x['name'] == selsink }
  return '<NO SINK>' unless sink

  name = sink['properties']['alsa.name']
  name = sink['description'] if name.nil?
  name || '<NO SINK>'
end

def muted?
  `pactl get-sink-mute @DEFAULT_SINK@`.chop.end_with?('yes')
end

def notify_volume
  vol = read_volume
  icon = if vol < 50
           'audio-volume-low-symbolic'
         elsif vol >= 50 && vol <= 75
           'audio-volume-medium-symbolic'
         elsif vol > 75 && vol <= 100
           'audio-volume-high-symbolic'
         else
           'audio-volume-overamplified-symbolic'
         end

  system "dunstify -a #{VOLUME_APP} -h int:value:#{vol} -i #{icon} -u low '#{vol}% [#{current_sink}]'"
end

def read_volume
  `pactl get-sink-volume @DEFAULT_SINK@`.scan(%r{/\s*(\d+)%\s*/})
                                        .flatten
                                        .map(&:to_i)
                                        .max
end

def write_volume(level)
  toggle_mute if muted?
  system "pactl set-sink-volume @DEFAULT_SINK@ #{level}"
  notify_volume
end

def toggle_mute
  system 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

  if muted?
    system "dunstify -a #{VOLUME_APP} -i audio-volume-muted-symbolic -u low 'OFF [#{current_sink}]'"
  else
    notify_volume
  end
end

unless ARGV.empty?
  case ARGV[0]
  when 'set-volume'
    write_volume ARGV[1]
  when 'toggle-mute'
    toggle_mute
  else
    puts "Action #{ARGV[0]} is not valid"
    exit 1
  end
end
