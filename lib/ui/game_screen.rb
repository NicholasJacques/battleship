module UI
  class GameScreen
    def initialize(parent_window, game)
      @user_board = Board.new(parent_window, game.user.board, 3, 3)
      @ai_board = Board.new(parent_window, game.ai.board, 16, 3)
    end

    def render
      @user_board.refresh
      @ai_board.refresh
    end
  end
end