require './lib/ui/common.rb'

module UI
  class Board
    include Common

    def initialize(parent_window, board_data, row, column, label)
      @parent_window = parent_window
      @board_data = board_data
      @label = label
      @container = build_container(row, column)
      @board = build_board
    end

    def build_container(row, column)
      board_name = "#{@label.capitalize}'s Board"
      result = @parent_window.subwin(12, 22, row, column)
      center_x(result, 0, board_name)

      x_labels = "  " + (1..10).to_a.join(' ')
      result.setpos(1, 0)
      result.addstr(x_labels)
      y_labels = ('A'..'J').to_a
      y_labels.each_with_index do |label, y|
        result.setpos(y+2, 0)
        result.addstr(label)
      end
      result
    end

    def build_board
      result = @container.derwin(10, 19, 2, 2)
      @board_data.grid.each_with_index do |row, y|
        result.setpos(y,0)
        row_string = row.map {|cell| cell.render}.join(' ')
        result.addstr(row_string)
      end
      result
    end

    def refresh
      @container.refresh
      @board.refresh
    end
  end
end
