module UI
  class Base
  
    attr_accessor :parent, :window
    def initialize(parent, props = {})
      @parent = parent
      @props = props
      @window = nil
      @child_windows = []
    end

    def render
      set_content
      @window.refresh
      @child_windows.each(&:render)
    end
  
    def refresh
      @window.refresh
      # @child_windows.each(&:refresh)
    end

    def set_content
      nil
    end

    def run
      nil
    end

    def clear
      @window.clear
    end

    def close
      @window.close
    end
  
    def center_x(line, text)
      width = @window.maxx
      x = (width - text.length) / 2
      @window.setpos(line, x)
      @window.addstr(text)
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
  
    def get_user_input_string
      input = @window.getstr
      if input == 'quit'
        Curses.close_screen
        exit
      else
        input
      end
    end

  end
end
