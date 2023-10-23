#!/bin/env ruby

require 'fileutils'
require 'optparse'
require 'tmpdir'
require 'time'

def gen_filename
  time = Time.now.strftime '%d%m%Y_%H%M%S'
  "Screenshot_#{time}.png"
end

def grab_active_window
  activewin = `xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"`
  activewin.match(/window id # (.+)/)[1].to_i 16
end

def clipboard_copy(filepath)
  system("echo 'file://#{filepath}' | xclip -selection clipboard -t text/uri-list")
end

def notify(title)
  system("dunstify -a 'Screenshot' '#{title}' -i accessories-screenshot")
end

class Modes
  FULL      = 0
  ACTIVE    = 1
  SELECTION = 2
end

options = {
  mode: Modes::FULL,
  clipboard: false
}

OptionParser.new do |opt|
  opt.on('-m', '--mode MODE', 'Screenshot mode (full, active, selection)') do |mode|
    options[:mode] = case mode
                     when 'active'
                       Modes::ACTIVE
                     when 'selection'
                       Modes::SELECTION
                     else
                       Modes::FULL
                     end
  end

  opt.on('-c', '--clipboard', 'Copy image to Clipboard') { options[:clipboard] = true }
end.parse!

filepath = if options[:clipboard]
             File.join Dir.tmpdir, 'screenshot.png'
           else
             File.join Dir.home, gen_filename
           end

case options[:mode]
when Modes::ACTIVE
  system("maim --window #{grab_active_window} #{filepath}")
when Modes::SELECTION
  system("maim --select #{filepath}")
else
  system("maim #{filepath}")
end

if options[:clipboard]
  clipboard_copy filepath
  notify 'Copied to clipboard'
else
  notify 'Saved'
end
