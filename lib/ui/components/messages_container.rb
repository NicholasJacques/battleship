module UI
  class Messages < Window
    def initialize(*args)
      super(*args)
    end

    def render
      @window.box('|', '-')
      @game.messages.last(22).each_with_index do |message, index|
        @window.setpos(index+1, 2)
        @window.addstr(message)
      end
      @window.refresh
    end

  end
end
