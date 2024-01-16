require './lib/ui/base.rb'

module UI
  class Board < Base

    def initialize(parent, row, column, props={})
      super(parent)
      @window = @parent.window.derwin(10, 19, row, column)
      @board_data = props[:board_data]
      @show_ships = props[:show_ships]
    end

    def set_content
      @board_data.grid.each_with_index do |row, y|
        @window.setpos(y,0)
        row.each_with_index do |cell, i|
          @window.setpos(y, i*2)
          render_cell(cell)
        end
      end
    end

    def render_cell(cell)
      Curses.init_pair(1, 1, 0)
      if cell.is_hit? && cell.ship
        @window.attrset(Curses.color_pair(1))
        @window.addstr(cell.render(show_ships: @show_ships))
        @window.attrset(Curses.color_pair(0))
      else
        @window.addstr(cell.render(show_ships: @show_ships))
      end
    end

  end
end
