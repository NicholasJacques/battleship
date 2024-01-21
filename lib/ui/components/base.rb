require './lib/ui/positionable.rb'

module UI
  class Base
    
    attr_reader :parent, :game_state, :children
    def initialize(parent, game_state)
      @parent = parent
      @game_state = game_state
      @children = []
    end
  end

  class Window < Base
    include Positionable

    attr_reader :window, :props
    def initialize(parent, game_state, height, width, top, left, props={})
      super(parent, game_state)
      @window = parent.window.derwin(height, width, top, left)
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
