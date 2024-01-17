require 'curses'
require './lib/ui/positionable.rb'
require './lib/ui/components/board_container.rb'
require './lib/ui/components/console_container.rb'

module UI
  class GameScreen
    include Positionable

    def initialize(game)
      @game = game
      @window = Curses.stdscr
      @user_board = BoardContainer.new(self, 12, 22, 16, 3, {label: @game.user.name, show_ships: true, board_data: @game.user.board})
      @ai_board = BoardContainer.new(self, 12, 22, 3, 3, {label: 'Opponent', show_ships: false, board_data: @game.ai.board})
      @console = ConsoleContainer.new(self, 4, 54, 36, 3, {game: @game})
      @child_windows = [@user_board, @ai_board, @console]
      Curses.start_color
    end

    def render
      @child_windows.each(&:render)
      @window.refresh
    end

    def run
      place_ships
      take_turns
    end

    def place_ships
      manual_placement = @console.prompt(
        "Would you like to place your own ships? (Y/N)",
        ->(answer) { ['Y', 'N'].include?(answer) }
      )

      if manual_placement == 'Y'
        @game.user.ship_placement_strategy = ManualShipPlacementStrategy
        @game.user.board.ships.each do |ship|
          @console.prompt(
            "Place your #{ship.name.capitalize} (length: #{ship.size}):",
            ->(answer) { @game.user.ship_placement_strategy.place_ship(ship, @game.user.board, answer) }
          )
          @user_board.render
        end
      else
        @game.user.ship_placement_strategy = RandomShipPlacementStrategy
        @game.user.place_ships
        @user_board.render
      end
      @game.ai.place_ships
      render
    end

    def take_turns
      until @game.over? do
        @console.prompt(
          "Choose A location to fire at:",
          ->(answer) { @game.user.fire(answer) }
        )
        @game.ai.fire
        render
      end
    end

    def to_s
      "GameScreen"
    end

  end
end