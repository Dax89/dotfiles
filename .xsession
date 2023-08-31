#! /bin/ruby

def execute_if(cmd, args = '')
  system("#{cmd} #{args}") if system("command -v #{cmd} > /dev/null")
end

execute_if 'numlockx'
system 'xset r rate 250 50'
system 'i3'
