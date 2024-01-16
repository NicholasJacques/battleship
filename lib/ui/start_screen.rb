require './lib/ui/base.rb'

module UI
  class StartScreen < Base
    def initialize(parent_window)
      super(parent_window)
      @window = parent_window
      hide_cursor
    end

    def set_content
      center_text("Battleship!")
      footer_text("Press any key to continue")
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
      center_text("Battleship!")
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

    def ask_name
      show_cursor
      @window.clear
      center_text("Battleship!")
      footer_text("What is your name? ")
      @window.refresh
      name = @window.getstr
      hide_cursor
      name
    end
  end
end