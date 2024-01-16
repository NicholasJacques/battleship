require './lib/ui/base.rb'
require './lib/ui/board_container.rb'
require './lib/ui/console_container.rb'

module UI
  class GameScreen < Base
    def initialize(parent, game)
      super(parent)
      @window = parent
      @game = game
    end

    def set_content
      @user_board = BoardContainer.new(self, @game.user.board, 16, 3, @game.user.name)
      @ai_board = BoardContainer.new(self, @game.ai.board, 3, 3, 'Opponent')
      @console = ConsoleContainer.new(self, @game)
      @child_windows = [@user_board, @ai_board, @console]
    end

    def prompt
      @console.prompt
    end

    def run
      sleep(100)
    end

  end
end