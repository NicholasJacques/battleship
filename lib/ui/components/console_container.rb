require './lib/ui/components/console.rb'

module UI
  class ConsoleContainer < Window

    attr_reader :console
    def initialize(**kwargs)
      super(**kwargs)
      @console = Console.new(
        parent: self, 
        game_state: game_state, 
        height: 3, 
        width: 54, 
        top: 1, 
        left: 0, 
        props: props
      )
      children << @console
    end

    def render
      reset_prompt
      window.setpos(0, 1)
      window.addstr(game_state.get_prompt)
      console.window.setpos(1, 2)

      children.each(&:render)
      window.refresh
    end

    def prompt
      answer = console.prompt
      reset_prompt
      return answer
    end

    def reset_prompt
      window.setpos(0, 1)
      window.addstr(' ' * (window.maxx - 1))
      window.setpos(0, 1)
      window.refresh
    end
  end
end