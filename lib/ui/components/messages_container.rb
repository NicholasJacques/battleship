require './lib/ui/components/base.rb'
require './lib/ui/components/messages.rb'

module UI
  class MessagesContainer < Window

    def initialize(**kwargs)
      super(**kwargs)
      @messages = Messages.new(
        parent: self, 
        game_state: game_state, 
        height: 9, 
        width: 52, 
        top: 1, 
        left: 1
      )
      children << @messages
    end

    def render
      window.box('|', '-')
      center_x(0, " Messages ")
      children.each(&:render)
    end

  end
end