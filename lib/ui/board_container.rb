require './lib/ui/base.rb'
require './lib/ui/board.rb'

module UI
  class BoardContainer < Base
    def initialize(parent_window, board_data, row, column, label)
      super(parent_window)
      @window = @parent.subwin(12, 22, row, column)
      @label = "#{label.capitalize}'s Board"
      @board_content = Board.new(@window, board_data)
      @child_windows = [@board_content]
    end
  
    # def render
    #   set_content
    #   @window.refresh
    #   @child_windows.each(&:render)
    # end
  
    def set_content
      center_x(0, @label)
      x_labels = "  " + (1..10).to_a.join(' ')
      @window.setpos(1, 0)
      @window.addstr(x_labels)
      y_labels = ('A'..'J').to_a
      y_labels.each_with_index do |label, y|
        @window.setpos(y+2, 0)
        @window.addstr(label)
      end
    end
  end
end
