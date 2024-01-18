require 'curses'
require './lib/ui/positionable.rb'
require './lib/ui/components/board_container.rb'
require './lib/ui/components/console_container.rb'
require './lib/ui/components/messages_container.rb'

module UI
  class GameScreen
    include Positionable

    def initialize(game)
      @game = game
      @window = Curses.stdscr
      @user_board = BoardContainer.new(self, @game, 12, 22, 16, 3, {label: @game.user.name, show_ships: true, board_data: @game.user.board})
      @ai_board = BoardContainer.new(self, @game, 12, 22, 3, 3, {label: 'Opponent', show_ships: false, board_data: @game.ai.board})
      @console = ConsoleContainer.new(self, @game, 4, 54, 36, 3)
      @messages = Messages.new(self, @game, 24, 30, 4, 30)
      @child_windows = [@user_board, @ai_board, @console, @messages]
      Curses.start_color
    end

    def render
      Curses.curs_set(0)
      header_text("BATTLESHIP")
      @child_windows.each(&:render)
      @window.refresh
    end

    def run
      loop do
        render
        input = @console.prompt
        if input == 'quit'
          Curses.close_screen
          exit
        else
          @game.process_input(input)
        end
      end
    end

  end
end