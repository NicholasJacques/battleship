require 'curses'

module UI
  class MainMenu
    include Positionable

    attr_reader :window
    def initialize
      @window = Curses.stdscr
      Curses.stdscr.keypad = true
    end

    def render
      center_text("BATTLESHIP")
      @menu = Curses::Menu.new([
        Curses::Item.new("New Game", ''),
        Curses::Item.new("Exit", ''),
      ])
      height, width = @menu.scale
      top = ((window.maxy - height) / 2) + 3
      left = (window.maxx - width) / 2

      menu_window = window.derwin(height, width, top, left)
      @menu.set_sub(menu_window)
      @menu.post
      window.refresh
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

    def tear_down
      Curses.stdscr.keypad = true
      window.clear
      Curses.close_screen
    end
  end
end