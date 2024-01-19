require './lib/ui/components/base.rb'
require './lib/ui/components/messages.rb'

module UI
  class MessagesContainer < Window

    def initialize(*args)
      super(*args)
      @messages = Messages.new(self, @game_state, 9, 52, 1, 1)
      @child_windows = [@messages]
    end

    def render
      @window.box('|', '-')
      center_x(0, " Messages ")
      @child_windows.each(&:render)
    end

  end
end