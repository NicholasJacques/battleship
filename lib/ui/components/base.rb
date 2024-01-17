module UI
  class Base
    def initialize(parent)
      @parent = parent
      @children = []
    end
  end

  class Window < Base
    include Positionable

    def initialize(parent, height, width, top, left, props={})
      super(parent)
      @window = @parent.window.derwin(height, width, top, left)
      @props = props
    end
  end
end
