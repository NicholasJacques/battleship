require 'minitest/autorun'
require './lib/cell.rb'
require './lib/ship.rb'


describe Cell do
  describe '#to_s' do
    it 'returns the position' do
      assert_equal 'A1', Cell.new('A1').to_s
    end
  end

  describe '#is_hit?' do
    it 'returns true if the cell has been hit' do
      cell = Cell.new('A1')
      cell.hit = true
      assert_equal true, cell.is_hit?
    end

    it 'returns false if the cell has not been hit' do
      cell = Cell.new('A1')
      assert_equal false, cell.is_hit?
    end
  end

  describe '#render' do
    it "returns '.' if the cell has not been hit and there is no ship" do
      cell = Cell.new('A1')
      assert_equal '.', cell.render
    end

    it "returns 'X' if the cell has been hit and there is no ship" do
      cell = Cell.new('A1')
      cell.hit = true
      assert_equal 'X', cell.render
    end

    it "returns the first letter of the ship's name if the cell contains a ship and show_ships=true" do
      cell = Cell.new('A1')
      cell.ship = Ship.new('carrier', 5)
      assert_equal 'C', cell.render
    end

    it "returns '.' if the cell contains a ship and show_ships=false" do
      cell = Cell.new('A1')
      cell.ship = Ship.new('carrier', 5)
      assert_equal '.', cell.render(show_ships: false)
    end

    it "returns the first letter of the ship's name with a strikethrough if the cell contains a ship and show_ships=true" do
      cell = Cell.new('A1')
      cell.hit = true
      cell.ship = Ship.new('carrier', 5)
      assert_equal "H", cell.render
    end
  end
end