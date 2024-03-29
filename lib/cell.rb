class Cell
  attr_accessor :ship, :hit
  attr_reader :position

  def initialize(position)
    @position = position
    @ship = nil
    @hit = false
  end

  def to_s
    position
  end

  def is_hit?
    hit
  end

  def is_ship_hit?
    is_hit? && ship
  end

  def render(show_ships: true)
    if is_ship_hit? && ship.sunk?
      ship.name[0].upcase
    elsif is_ship_hit?
      'H'
    elsif ship && show_ships
      ship.name[0].upcase
    elsif is_hit?
      "X"
    else
      "."
    end
  end

  def ==(other)
    return false if other.nil?
    position == other.position
  end
end