require './lib/ui/components/base.rb'
require './lib/ui/components/messages.rb'

module UI
  class MessagesContainer < Window

    def initialize(*args)
      super(*args)
      @messages = Messages.new(self, game_state, 9, 52, 1, 1)
      children << @messages
    end

    def render
      window.box('|', '-')
      center_x(0, " Messages ")
      children.each(&:render)
    end

  end
end