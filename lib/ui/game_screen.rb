module UI
  class GameScreen
    def initialize(parent_window, game)
      @parent_window = parent_window
      @game = game
      @user_board = Board.new(parent_window, game.user.board, 3, 3, @game.user.name)
      @ai_board = Board.new(parent_window, game.ai.board, 16, 3, 'Opponent')
    end

    def render
      @parent_window.refresh
      @user_board.refresh
      @ai_board.refresh
    end
  end
end