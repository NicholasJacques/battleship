require 'curses'
require './lib/ui/board.rb'
require './lib/ui/game_screen.rb'
require './lib/ui/start_screen.rb'

module UI
  class UI
    attr_reader :window
  
    def initialize(game)
      @game = game
      @window = Curses.init_screen
      @current_screen = start_screen
    end

    def start_screen
      @start_screen ||= StartScreen.new(@window)
    end

    def game_screen
      @game_screen ||= GameScreen.new(@window, @game)
    end

    def start
      @current_screen = start_screen
      render
      @window.getch
      if !start_screen.correct_dimensions?
        start_screen.resize_window_prompt
      end
      @game.user.name = start_screen.ask_name
    end

    def play_game
      @window.clear
      @current_screen = game_screen
      @current_screen.render
    end

    def render
      @current_screen.render
    end

    def prompt
      @current_screen.prompt
    end

  end
end
