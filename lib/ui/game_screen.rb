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
      @user_board = BoardContainer.new(self, 16, 3, {label: @game.user.name, show_ships: true, board_data: @game.user.board})
      @ai_board = BoardContainer.new(self, 3, 3, {label: 'Opponent', show_ships: false, board_data: @game.ai.board})
      @console = ConsoleContainer.new(self, 36, 3, @game)
      @child_windows = [@user_board, @ai_board, @console]
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
      @game.ai.fire_strategy = FireStrategyFactory.create(:random, @game.user.board)
      render
    end

    def take_turns
      until @game.over? do
        @console.prompt(
          "Choose A location to fire at:",
          ->(answer) { @game.user.fire_strategy.fire(answer) }
        )
        @game.ai.fire
        render
      end
    end

  end
end