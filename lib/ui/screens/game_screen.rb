require 'curses'
require './lib/ui/components/board_container.rb'
require './lib/ui/components/console_container.rb'
require './lib/ui/components/messages_container.rb'

module UI
  class GameScreen
    include Positionable

    def initialize(game_state)
      @game_state = game_state
      @window = Curses.stdscr
      @user_board = BoardContainer.new(self, @game_state, 12, 22, 3, 3, {label: @game_state.user_name, show_ships: true, board_data: @game_state.user_board})
      @ai_board = BoardContainer.new(self, @game_state, 12, 22, 3, 30, {label: 'Opponent', show_ships: false, board_data: @game_state.ai_board})
      @console = ConsoleContainer.new(self, @game_state, 4, 54, 36, 3)
      @messages = Messages.new(self, @game_state, 10, 54, 25, 3)
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
        sleep(0.1)
        render
        if @game_state.current_action_requires_input?
          input = @console.prompt
          if input == 'quit'
            Curses.close_screen
            exit
          else
            @game_state.process_input(input)
          end
        else
          @game_state.process_action
        end
      end
    end

  end
end