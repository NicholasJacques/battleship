require './lib/ui/base.rb'

module UI
  class Board < Base

    def initialize(parent, board_data)
      super(parent)
      @window = @parent.window.derwin(10, 19, 2, 2)
      @board_data = board_data
    end

    def set_content
      @board_data.grid.each_with_index do |row, y|
        @window.setpos(y,0)
        row_string = row.map {|cell| cell.render}.join(' ')
        @window.addstr(row_string)
      end
    end

  end
end
