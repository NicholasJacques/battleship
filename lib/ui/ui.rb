require 'curses'
require './lib/game.rb'
require './lib/ui/game_screen.rb'
require './lib/ui/menu_screen.rb'
require './lib/ui/start_screen.rb'

module UI
  class UI
    attr_reader :window
  
    def initialize
      @game = nil
      @window = Curses.init_screen
      Curses.cbreak
      Curses.noecho
      Curses.start_color
    end

    def start_screen
      @start_screen ||= StartScreen.new(@window)
    end

    def game_screen
      @game_screen ||= GameScreen.new(@window, @game)
    end

    def menu_screen
      @menu_screen ||= MenuScreen.new(@window)
    end

    def start
      start_screen.render
      start_screen.run
      @window.clear
      main_menu
    end

    def main_menu
      menu_screen.render
      next_action = menu_screen.run
      @window.clear
      case next_action
      when 'New Game'
        play_game
      when 'Exit'
        exit
      end
    end

    def play_game
      @game = Game.new
      game_screen.render
      game_screen.run
      @window.clear
    end

  end
end
