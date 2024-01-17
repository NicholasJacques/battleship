require './lib/ui/components/base.rb'
require './lib/ui/components/console.rb'

module UI
  class ConsoleContainer < Window
    def initialize(*args)
      super(*args)
      @console = Console.new(self, 3, 54, 1, 0, @props)
      @child_windows = [@console]
    end

    def render
      @child_windows.each(&:render)
      @window.refresh
    end

    def prompt(message, validate_response)
      reset_prompt
      @window.setpos(0, 1)
      @window.addstr(message)
      @console.window.setpos(1, 2)
      render
      return @console.prompt(validate_response)
    end

    def reset_prompt
      @window.setpos(0, 1)
      @window.addstr(' ' * (@window.maxx - 1))
      @window.setpos(0, 1)
      @window.refresh
    end

    def to_s
      "ConsoleContainer"
    end
  end
end