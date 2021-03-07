require "test_helper"

class CoordinateTest < ActiveSupport::TestCase

  test 'Should not save coordinate without a street' do
    coordinate = Coordinate.new
    assert_not coordinate.save
  end

  test 'Street should have at least 8 characters' do
    coordinate = Coordinate.new
    coordinate[:street] = 'seven__'  # 7 chars
    assert_not coordinate.save
  end

  test 'Should not save coordinate without a zipcode' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    assert_not coordinate.save
  end

  test 'Zipcode should be a number' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 'Hello'
    assert_not coordinate.save
    coordinate[:zip_code] = true
    assert_not coordinate.save
  end

  test 'Zipcode should have at least 4 digits' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 333
    assert_not coordinate.save
  end

  test 'Zipcode should have no more than 5 digits' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 333_333
    assert_not coordinate.save
  end

  test 'Should not save coordinate without a city' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 3_333
    assert_not coordinate.save
  end

  test 'City should have at least 3 characters' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 3_333
    coordinate[:city] = 'Ah'
    assert_not coordinate.save
  end

  test 'Should not save coordinate without a country' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 3_333
    coordinate[:city] = 'Brussels'
    assert_not coordinate.save
  end

  test 'Country should have at least 3 characters' do
    coordinate = Coordinate.new
    coordinate[:street] = 'Grand Rue'
    coordinate[:zip_code] = 3_333
    coordinate[:city] = 'Brussels'
    coordinate[:country] = 'Be'
    assert_not coordinate.save
  end

  test 'Cain\'s street' do
    coordinate = coordinates(:cain)
    assert_equal('Betrayal\'s street, 1', coordinate[:street])
  end

  test 'Cain\'s zip_code' do
    coordinate = coordinates(:cain)
    assert_equal(1000, coordinate[:zip_code])
  end

  test 'Abel\'s city' do
    coordinate = coordinates(:abel)
    assert_equal('Namur', coordinate[:city])
  end

  test 'Abel\'s country' do
    coordinate = coordinates(:abel)
    assert_equal('Belgium', coordinate[:country])
  end

  test 'Should update Cain\'s street' do
    coordinate = coordinates(:cain)
    coordinate.update({ street: 'Rue de la Joie' })
    coordinate = coordinates(:cain)
    assert_equal 'Rue de la Joie', coordinate[:street]
  end

  test 'Should update Abel\'s zip_code' do
    coordinate = coordinates(:abel)
    assert_not coordinate.update({ zip_code: 'Hell' })
    coordinate = coordinates(:abel)
    assert_not_equal 5000, coordinate[:zip_code]
  end

  test 'Should delete Cain' do
    coordinate = coordinates(:cain)
    assert coordinate.delete
  end

end
