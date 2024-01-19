Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each do |file|
  require file unless file == './lib/runner.rb'
end

require 'pry-byebug'; binding.pry
puts 'exit'

# require 'curses'

# Curses.init_screen

# scr = Curses.init_screen()
# starting_height = 0

# window = Curses::Window.new(12, 22, 1, 1)
# window.box('|', '-')
# pad = Curses::Pad.new(1, 20)
# 20.times do |i|
#   pad.resize(i + 1, 20)
#   pad.setpos(i, 1)
#   pad.addstr("This is line #{i}")
#   # pad.refresh(0, 0 , 2, pad.maxy-10, 12, 22)
# end

# window.refresh
# pad.refresh(pad.maxy-10, 0 , 2, 2, 12, 22)
# window.getch


# pad = Curses::Pad.new(20, 30)
# pad.box('|', '-')
# 20.times do |i|
#   pad.resize(i + 1, 20)
#   pad.setpos(i, 1)
#   pad.addstr("This is line #{i}")
#   # pad.refresh(0, 0 , 2, pad.maxy-10, 12, 22)
# end


pad.refresh(0, 0, 2, 2, 22, 32)

pad.getch



# Curses.noecho
# Curses.cbreak()
# Curses.crmode
# window.keypad = true

# 1.step do |i|
#   Curses.mousemask(Curses::ALL_MOUSE_EVENTS)

#   input = window.getch
#   scr.setpos(i, 20)
#   m = Curses.getmouse
#   scr.addstr("Input: #{input.inspect} #{input}, #{m.bstate}")
#   scr.refresh
# end

# 2097152
# 65536