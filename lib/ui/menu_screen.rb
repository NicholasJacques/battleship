require 'curses'

require './lib/ui/base.rb'

module UI
  class MenuScreen < Base
    def initialize(parent_window)
      super(parent_window)
      @window = parent_window
    end
  
    def set_content
      Curses.stdscr.keypad = true
      center_text("BATTLESHIP")
      @menu = Curses::Menu.new([
        Curses::Item.new("New Game", ''),
        Curses::Item.new("Exit", ''),
      ])
      height, width = @menu.scale
      top = ((@window.maxy - height) / 2) + 3
      left = (@window.maxx - width) / 2

      menu_window = @window.derwin(height, width, top, left)
      @menu.set_sub(menu_window)
      @menu.post
      menu_window.refresh
    end

    def run
      while ch = Curses.getch
        begin
          case ch
          when Curses::KEY_UP, ?k
            @menu.up_item
          when Curses::KEY_DOWN, ?j
            @menu.down_item
          when Curses::KEY_ENTER, ?\n, ?\r, ?\l, 10
            return @menu.current_item.name
          end
        rescue Curses::RequestDeniedError
        end
      end
    end
  end
end
