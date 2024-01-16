require './lib/ui/base.rb'
require './lib/ui/board.rb'

module UI
  class BoardContainer < Base
    def initialize(parent, row, column, props={})
      super(parent, props)
      @window = @parent.window.subwin(12, 22, row, column)
      @label = "#{@props[:label].capitalize}'s Board"
      @board_content = Board.new(self, 2, 2, {board_data: @props[:board_data], show_ships: @props[:show_ships]})
      @child_windows = [@board_content]
    end
  
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
