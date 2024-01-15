module UI
  class StartScreen
    def initialize(parent_window)
      @window = parent_window
    end

    def render
      @window.clear
      center_text("Battleship!")
      footer_text("Press any key to continue")
      @window.refresh
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

    def center_text(text)
      height, width = @window.maxy, @window.maxx
      x = (width - text.length) / 2
      y = height / 2
      @window.setpos(y, x)
      @window.addstr(text)
    end
  
    def footer_text(text)
      height, width = @window.maxy, @window.maxx
      x = (width - text.length) / 2
      y = height - 1
      @window.setpos(y, x)
      @window.addstr(text)
    end

    def x_center
      @window.maxx / 2
    end
  
    def y_center
      @window.maxy / 2
    end

    def hide_cursor
      Curses.curs_set(0)
    end

    def show_cursor
      Curses.curs_set(1)
    end

    def clear_screen
      @window.clear
      @window.refresh
    end
  end
end