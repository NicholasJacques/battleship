class Ship
  attr_reader :name, :size
  attr_accessor :positions

  def initialize(name, size)
    @name = name
    @size = size
    @hits = 0
    @positions = []
  end

  def sunk?
    @hits == @size
  end

  def hit
    @hits += 1
  end

  def <=>(other)
    name <=> other.name
  end

end