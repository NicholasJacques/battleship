module UI
  class Board < Window
    def initialize(*args)
      super(*args)
    end

    def render
      @props[:board_data].grid.each_with_index do |row, y|
        @window.setpos(y,0)
        row.each_with_index do |cell, i|
          @window.setpos(y, i*2)
          render_cell(cell)
        end
      end
      @window.refresh
    end

    def render_cell(cell)
      Curses.init_pair(1, 1, 0)
      if cell.is_hit? && cell.ship
        @window.attrset(Curses.color_pair(1))
        @window.addstr(cell.render(show_ships: @props[:show_ships]))
        @window.attrset(Curses.color_pair(0))
      else
        @window.addstr(cell.render(show_ships: @props[:show_ships]))
      end
    end

    def to_s
      "Board"
    end
  end
end