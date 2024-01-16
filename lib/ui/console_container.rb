require './lib/ui/base.rb'
require './lib/ui/game_console.rb'

module UI
  class ConsoleContainer < Base
    def initialize(parent, game)
      super(parent)
      @window = @parent.window.derwin(4, 54, 36, 3)
      @game = game
      @console = GameConsole.new(self, game)
      @child_windows = [@console]
    end

    def set_content
      @window.setpos(0, 1)
      @window.addstr(@game.current_prompt)
    end

    def prompt
      @console.prompt
    end
  end
end