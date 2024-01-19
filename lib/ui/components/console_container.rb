require './lib/ui/components/console.rb'

module UI
  class ConsoleContainer < Window
    def initialize(*args)
      super(*args)
      @console = Console.new(self, @game_state, 3, 54, 1, 0, @props)
      @child_windows = [@console]
    end

    def render
      reset_prompt
      @window.setpos(0, 1)
      @window.addstr(@game_state.get_prompt)
      @console.window.setpos(1, 2)

      @child_windows.each(&:render)
      @window.refresh
    end

    def prompt
      answer = @console.prompt
      reset_prompt
      return answer
    end

    def reset_prompt
      @window.setpos(0, 1)
      @window.addstr(' ' * (@window.maxx - 1))
      @window.setpos(0, 1)
      @window.refresh
    end
  end
end