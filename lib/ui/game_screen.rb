require './lib/ui/base.rb'
require './lib/ui/board_container.rb'

module UI
  class GameScreen < Base
    def initialize(parent_window, game)
      super(parent_window)
      @window = parent_window
      @game = game
      @user_board = BoardContainer.new(parent_window, game.user.board, 16, 3, @game.user.name)
      @ai_board = BoardContainer.new(parent_window, game.ai.board, 3, 3, 'Opponent')
      @child_windows = [@user_board, @ai_board]
    end

  end
end