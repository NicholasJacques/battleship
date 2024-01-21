require 'curses'
require './lib/ui/positionable.rb'

module UI
  class StartScreen
    include Positionable

    attr_reader :window
    def initialize()
      @window = Curses.stdscr
      Curses.cbreak
      Curses.noecho
      Curses.curs_set(0)
    end

    def render
      center_text("BATTLESHIP")
      footer_text("Press any key to continue")
      @window.refresh
    end

    def run
      @window.getch
      if !correct_dimensions?
        resize_window_prompt
      end
    end

    def correct_dimensions?
      @window.maxx == 60 && @window.maxy == 40
    end

    def resize_window_prompt
      Signal.trap("SIGWINCH") do
        resize_window_guide_handler
      end
      resize_window_guide
      loop do
        input = @window.getch
        if input && input != 410
          break
        end
        sleep(0.1)
      end
    end

    def resize_window_guide
      center_text("BATTLESHIP")
      [ 
        "Before we begin, please resize your window to 60x40",
        "Current Size: #{@window.maxx}x#{@window.maxy}",
      ].each_with_index do |line, i|
        x = (@window.maxx - line.length) / 2
        y = y_center + i + 1
        @window.setpos(y, x)
        @window.addstr(line)
      end
  
      footer_text("Press any key when you are done")
      @window.refresh
    end

    def resize_window_guide_handler
      Curses.close_screen
      @window.refresh
      resize_window_guide
    end

    def tear_down
      Curses.close_screen
    end

  end
end