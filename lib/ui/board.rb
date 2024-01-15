require './lib/ui/base.rb'

module UI
  class Board < Base

    def initialize(parent_window, board_data)
      super(parent_window)
      @window = @parent.derwin(10, 19, 2, 2)
      @board_data = board_data
    end

    # def render
    #   set_content
    #   @window.refresh
    #   @child_windows.each(&:render)
    # end

    def set_content
      @board_data.grid.each_with_index do |row, y|
        @window.setpos(y,0)
        row_string = row.map {|cell| cell.render}.join(' ')
        @window.addstr(row_string)
      end
    end
  end
end
