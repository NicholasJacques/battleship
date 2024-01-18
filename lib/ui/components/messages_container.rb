module UI
  class Messages < Window
    def initialize(*args)
      super(*args)
    end

    def render
      @window.box('|', '-')
      @window.refresh
    end

  end
end
