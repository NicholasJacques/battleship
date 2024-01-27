require 'curses'
require './lib/ui/components/board_container.rb'
require './lib/ui/components/console_container.rb'
require './lib/ui/components/messages.rb'
require './lib/ui/components/messages_container.rb'

module UI
  class GameScreen
    include Positionable

    attr_reader :window, :game_state, :children
    def initialize(game_state)
      @game_state = game_state
      @window = Curses.stdscr
      @user_board = BoardContainer.new(
        parent: self,
        game_state: game_state, 
        height: 12, 
        width: 22, 
        top: 3, 
        left: 3, 
        props: {label: game_state.user_name, show_ships: true, board_data: game_state.user_board}
      )
      @ai_board = BoardContainer.new(
        parent: self, 
        game_state: game_state, 
        height: 12, 
        width: 22,
        top: 3, 
        left: 30, 
        props: {label: 'Opponent', show_ships: false, board_data: game_state.ai_board}
      )
      @console = ConsoleContainer.new(
        parent: self,
        game_state: game_state, 
        height: 4,
        width: 54,
        top: 36,
        left: 3
      )
      @messages = MessagesContainer.new(
        parent: self,
        game_state: game_state,
        height: 11,
        width: 54,
        top: 24, 
        left: 3
      )
      @children = [@user_board, @ai_board, @console, @messages]
      Curses.start_color
    end

    def render
      Curses.curs_set(0)
      header_text("BATTLESHIP")
      children.each(&:render)
      window.refresh
    end

    def run
      loop do
        sleep(0.1)
        render
        if game_state.current_action_requires_input?
          input = @console.prompt
          if input == 'quit'
            Curses.close_screen
            exit
          else
            game_state.process_input(input)
          end
        else
          game_state.process_action
        end
        break if game_state.quit?
      end
    end

    def tear_down
      Curses.clear
      Curses.close_screen
    end
  end
end