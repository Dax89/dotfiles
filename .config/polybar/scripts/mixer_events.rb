#!/bin/env /bin/ruby
# rubocop:disable Style/GlobalVars

require 'json'

unless ARGV.empty?
  case ARGV[0]
  when 'change'
    system "pactl set-sink-volume @DEFAULT_SINK@ #{ARGV[1]}"
    system 'pactl set-sink-mute @DEFAULT_SINK@ false'
  when 'toggle'
    system 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
  end

  exit
end

def headphone?
  h = false

  $sinks[$device]['ports'].each do |x|
    if x['type'] == 'Headphones'
      h = true
      break
    end
  end

  h
end

def bluetooth?
  $sinks[$device]['properties']['device.bus'] == 'bluetooth' ||
    BLUETOOTH_DRIVERS.include?($sinks[$device]['properties']['alsa.driver_name'])
end

def muted?
  $sinks[$device]['mute']
end

def icon
  if bluetooth?
    muted? ? '%{F#dfae68}%{T2}󰗿%{T-}%{F-}' : '%{F#6699cc}%{T2}󰗾%{T-}%{F-}'
  elsif headphone?
    muted? ? '%{F#dfae68}%{T2}󰟎%{T-}%{F-}' : '%{F#6699cc}%{T2}󰋋%{T-}%{F-}'
  else
    muted? ? '%{F#dfae68}%{T2}󰖁%{T-}%{F-}' : '%{F#6699cc}%{T2}󱄡%{T-}%{F-}'
  end
end

def volume
  current = $sinks[$device]
  volume = '???'

  unless current['volume'].nil?
    current['channel_map'].split(',').reverse!.each do |ch|
      volume = current['volume'][ch]['value_percent']
    end
  end

  volume
end

def current_device
  `pactl get-default-sink`.chomp!
end

def current_sinks
  JSON.parse(`pactl -f json list sinks`).each_with_object({}) do |x, acc|
    acc[x['name']] = x
  end
end

BLUETOOTH_DRIVERS = ['xone_gip_headset'].freeze
$stdout.sync = true

$device = current_device
$sinks = current_sinks

def device_changed
  currdevice = current_device
  return if $device == currdevice

  $device = currdevice
  $sinks = current_sinks
  puts "#{icon} #{volume}"
end

def device_updated
  $sinks = current_sinks
  puts "#{icon} #{volume}"
end

puts "#{icon} #{volume}"

IO.popen('pactl subscribe').each_line do |x|
  m = /Event 'change' on (server|sink) #[0-9]+/.match(x)
  next if m.nil?

  case m[1]
  when 'server'
    device_changed
  when 'sink'
    device_updated
  end
end

# rubocop:enable Style/GlobalVars