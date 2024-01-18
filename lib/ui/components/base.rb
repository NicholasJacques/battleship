module UI
  class Base
    def initialize(parent, game)
      @parent = parent
      @game = game
      @children = []
    end
  end

  class Window < Base
    include Positionable

    def initialize(parent, game, height, width, top, left, props={})
      super(parent, game)
      # Curses.close_screen
      # require 'pry'; binding.pry
      @window = @parent.window.derwin(height, width, top, left)
      @props = props
    end
  end

  # class Pad < Base
  #   def initialize(parent, height, width, props={})
  #     super(parent)
  #     @window = Curses::Pad.new(height, width)
  #   end
  # end
end
