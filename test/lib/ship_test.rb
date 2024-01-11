require 'minitest/autorun'
require './lib/ship.rb'

describe Ship do
  describe '#hit' do
    it 'increments the number of hits' do
      ship = Ship.new('carrier', 5)
      ship.hit
      assert_equal 1, ship.hits
      ship.hit
      assert_equal 2, ship.hits
    end
  end

  describe '#sunk?' do
    it 'returns true if all of the ships positions have been hit' do
      ship = Ship.new('carrier', 5)
      ship.positions = ['A1', 'A2', 'A3', 'A4', 'A5']
      5.times { ship.hit }
      assert_equal true, ship.sunk?
    end

    it 'returns false if the ships has been hit a few times but not sunk' do
      ship = Ship.new('carrier', 5)
      ship.positions = ['A1', 'A2', 'A3', 'A4', 'A5']
      4.times { ship.hit }
      assert_equal false, ship.sunk?
    end
  end

  describe '#<=>' do
    it 'can sort the ship alphabetically by name' do
      assert_equal(
        [
          Ship.new('battleship', 4),
          Ship.new('carrier', 5),
          Ship.new('destroyer', 3),
          Ship.new('patrol boat', 2),
          Ship.new('submarine', 3),
        ],
        [
          Ship.new('carrier', 5),
          Ship.new('battleship', 4),
          Ship.new('destroyer', 3),
          Ship.new('submarine', 3),
          Ship.new('patrol boat', 2),
        ].sort
      )

    end
  end
end