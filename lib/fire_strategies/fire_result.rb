class FireResult
  attr_accessor :position, :cell, :is_hit, :is_sunk, :ship, :errors

  def initialize(position:, cell: nil, is_hit: false, is_sunk: false, ship: nil, errors: [])
    @position = position
    @cell = cell
    @is_hit = is_hit
    @is_sunk = is_sunk
    @ship = ship
    @errors = errors
  end
end