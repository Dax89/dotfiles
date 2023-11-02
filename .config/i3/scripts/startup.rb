#! /bin/env ruby

def execute_if(cmd)
  return if !system("which #{cmd}", out: File::NULL, err: File::NULL) ||
            system("pgrep -f #{cmd}", out: File::NULL)

  system "#{cmd} &"
end

system 'dunstify -a "Startup" "Starting applications"'

execute_if 'telegram-desktop'
execute_if 'thunderbird'
execute_if 'steam'
