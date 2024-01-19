require './lib/game_state_manager.rb'
require './lib/ui/screens/start_screen.rb'
require './lib/ui/screens/main_menu.rb'
require './lib/ui/screens/game_screen.rb'

module UI
  class UI
    attr_reader :window

    def start_screen
      @start_screen ||= StartScreen.new
    end

    def game_screen
      @game_screen ||= GameScreen.new(@game_state)
    end

    def menu_screen
      @menu_screen ||= MainMenu.new
    end

    def start
      start_screen.render
      start_screen.run
      start_screen.tear_down
      main_menu
    end

    def main_menu
      menu_screen.render
      next_action = menu_screen.run
      menu_screen.tear_down
      case next_action
      when 'New Game'
        play_game
      when 'Exit'
        exit
      end
    end

    def play_game
      @game_state = GameStateManager.create_game
      game_screen.render
      game_screen.run
      game_screen.tear_down
    end

  end
end
