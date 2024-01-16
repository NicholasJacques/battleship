require './lib/ui/base.rb'
require './lib/ui/game_console.rb'

module UI
  class ConsoleContainer < Base
    def initialize(parent, row, column, game)
      super(parent)
      @window = @parent.window.derwin(4, 54, row, column)
      @game = game
      @console = GameConsole.new(self, 1, 0, game)
      @child_windows = [@console]
    end

    # def set_content
    #   @window.setpos(0, 1)
    #   @window.addstr(@game.current_prompt)
    # end

    def prompt(message, validate_response)
      reset_prompt
      @window.setpos(0, 1)
      @window.addstr(message)
      @console.window.setpos(1, 2)
      refresh
      return @console.prompt(validate_response)
    end

    def reset_prompt
      @window.setpos(0, 1)
      @window.addstr(' ' * (@window.maxx - 1))
      @window.setpos(0, 1)
      @window.refresh
    end
  end
end