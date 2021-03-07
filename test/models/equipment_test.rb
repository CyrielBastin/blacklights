require "test_helper"

class EquipmentTest < ActiveSupport::TestCase

  test 'Should not save equipment without a name' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
    end

    assert_not equipment.save
  end

  test 'Equipment\'s name should contain at least 5 characters' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
      e[:name] = 'GGEZ'
    end

    assert_not equipment.save
  end

  test 'Should not save equipment without a description' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
      e[:name] = 'Hello'
    end

    assert_not equipment.save
  end

  test 'Equipment\'s description should contain at least 20 characters' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
      e[:name] = 'Hello'
      e[:description] = 'WV2paCwK4plV5At5jjO'  # 19 characters
    end

    assert_not equipment.save
  end

  test 'Should not save equipment without a unit price' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
      e[:name] = 'Hello'
      e[:description] = 'WV2paCwK4plV5At5jjO9'
    end

    assert_not equipment.save
  end

  test 'Equipment\'s unit price should be a number' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
      e[:name] = 'Hello'
      e[:description] = 'WV2paCwK4plV5At5jjO9'
      e[:unit_price] = 'Not a number'
    end

    assert_not equipment.save
  end

  test 'Equipment\'s unit price should be greater than 0.00' do
    equipment = Equipment.new do |e|
      e.category = categories(:balles)
      e.supplier = suppliers(:one)
      e.dimension = dimensions(:one)
      e[:name] = 'Hello'
      e[:description] = 'WV2paCwK4plV5At5jjO9'
      e[:unit_price] = 0
    end

    assert_not equipment.save
  end

  test 'Should update equipment\'s name to "Jacky"' do
    equipment = equipment(:raquette_de_badminton)
    equipment[:name] = 'Jacky'

    assert_equal 'Jacky', equipment[:name]
  end

  test 'Should update equipment\'s supplier\'s name to "Jacky"' do
    equipment = equipment(:raquette_de_badminton)
    equipment.supplier[:name] = 'Jacky'

    assert_equal 'Jacky', equipment.supplier[:name]
  end

  test 'Should update equipment\'s dimension\'s width to "3.33"' do
    equipment = equipment(:raquette_de_badminton)
    equipment.dimension[:width] = 3.33

    assert_equal 3.33, equipment.dimension[:width]
  end

  test 'Should delete equipment' do
    equipment = equipment(:balles_de_tennis)

    assert equipment.destroy
  end

end
