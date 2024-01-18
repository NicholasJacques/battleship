require './lib/ui/components/base.rb'
require './lib/ui/components/board.rb'

module UI
  class BoardContainer < Window
    def initialize(*args)
      super(*args)
      @board_content = Board.new(self, @game_state, 10, 19, 2, 2, {board_data: @props[:board_data], show_ships: @props[:show_ships]})
      @child_windows = [@board_content]
    end

    def render
      center_x(0, @props[:label])
      x_labels = "  " + (1..10).to_a.join(' ')
      @window.setpos(1, 0)
      @window.addstr(x_labels)
      y_labels = ('A'..'J').to_a
      y_labels.each_with_index do |label, y|
        @window.setpos(y+2, 0)
        @window.addstr(label)
      end
      @child_windows.each(&:render)
      @window.refresh
    end
  end
end