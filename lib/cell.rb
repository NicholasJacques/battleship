class Cell
  attr_accessor :ship, :hit
  attr_reader :position

  def initialize(position)
    @position = position
    @ship = nil
    @hit = false
  end

  def to_s
    @position
  end

  def is_hit?
    @hit
  end

  def hit_or_miss
    @hit && @ship ? :hit : :miss
  end

  def render(show_ships: true)
    if @ship && @ship.sunk?
      ship.name[0].upcase
    elsif @ship && is_hit?
      'H'
      # "\e[9m#{@ship.name[0].upcase}\e[0m" 
    elsif @ship && show_ships
      ship.name[0].upcase
    elsif is_hit?
      "X"
    else
      "."
    end
  end

  def ==(other)
    return false if other.nil?
    @position == other.position
  end
end