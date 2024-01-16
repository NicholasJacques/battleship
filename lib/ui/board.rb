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
        row_string = row.map {|cell| cell.render(show_ships: @show_ships)}.join(' ')
        @window.addstr(row_string)
      end
    end

  end
end
