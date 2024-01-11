class Ship
  attr_reader :name, :size, :hits
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

  def ==(other)
    return false if other.nil?
    @name == other.name &&
      @size == other.size &&
      @hits == other.hits &&
      @positions == other.positions
  end

end