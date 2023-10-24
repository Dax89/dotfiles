#!/bin/env ruby

def find_pid
  s = `pgrep -x redshift`.chomp
  return nil if s.empty?

  s.to_i
end

if ARGV[0] == 'toggle'
  pid = find_pid

  if pid.nil?
    system('redshift -v &')
  else
    system("kill -9 #{pid}")
    system('redshift -x')
  end

  exit 0
end

DAY   = 6500
NIGHT = 3500

def read_period
  periods = {
    'Daytime' => '%{F#6699cc}%{F-}',
    'Transition' => '%{F#dfae68}󰖚%{F-}',
    'Night' => '%{F#f7768e}󰖔%{F-}'
  }.freeze

  out = `redshift -p 2>&1 /dev/null`
  m = /Period: ([a-zA-Z]+)/.match out

  if m.nil? || !periods.key?(m[1])
    '%{F#efefef}%{F-}'
  else
    periods[m[1]]
  end
end

if find_pid.nil?
  puts '%{F#9ece6a}%{T2}󰔎%{T-}%{F-}'
else
  puts "%{T2}#{read_period}%{T-}"
end
