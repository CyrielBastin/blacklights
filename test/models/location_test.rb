# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  name          :string(255)
#  type          :string(255)
#  contact_id    :bigint
#  coordinate_id :bigint
#  dimension_id  :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class LocationTest < ActiveSupport::TestCase

  test 'Should not save location without a name' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)

    assert_not location.save
  end

  test 'Location\'s name should contain at least 3 characters' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'GG'

    assert_not location.save
  end

  test 'should not save a location with \'&\' in name' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga &'

    assert_not location.save
  end

  test 'should not save a location with \'+\' in name' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga +'

    assert_not location.save
  end

  test 'should not save a location with \'(\' in name' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga ('

    assert_not location.save
  end

  test 'should not save a location with \')\' in name' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga )'

    assert_not location.save
  end

  test 'should not save a location with \',\' in name' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga ,'

    assert_not location.save
  end

  test 'Should not save location without a type' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga'

    assert_not location.save
  end

  test 'should save location if type equals "private"' do
    location = Location.new
    location.user = users(:cain)
    location.dimension = dimensions(:one)
    location[:name] = 'Tortuga'
    location[:type] = 'private'
    location[:street] = 'djadjaojda'
    location[:city] = 'djadjaojda'
    location[:country] = 'djadjaojda'
    location[:zip_code] = 1000

    assert location.save
  end

  test 'should not save a location without a street' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
    end

    assert_not location.save
  end

  test 'should not save a location without a city' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
      l[:street] = 'Rue des Bergères'
    end

    assert_not location.save
  end

  test 'should not save a location with \'&\' in city' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
      l[:street] = 'Rue des Bergères'
      l[:city] = 'Paris &'
    end

    assert_not location.save
  end

  test 'should not save a location with \',\' in city' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
      l[:street] = 'Rue des Bergères'
      l[:city] = 'Paris ,'
    end

    assert_not location.save
  end

  test 'should not save a location without a country' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
      l[:street] = 'Rue des Bergères'
      l[:city] = 'Paris'
    end

    assert_not location.save
  end

  test 'should not save a location without a zip code' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
      l[:street] = 'Rue des Bergères'
      l[:city] = 'Paris'
      l[:country] = 'France'
    end

    assert_not location.save
  end

  test 'zip code should be a number' do
    location = Location.new do |l|
      l.user = users(:cain)
      l.dimension = dimensions(:one)
      l[:name] = 'Tortuga'
      l[:type] = 'public'
      l[:street] = 'Rue des Bergères'
      l[:city] = 'Paris'
      l[:country] = 'France'
      l[:zip_code] = 'Not a Number'
    end

    assert_not location.save
  end

  test 'Hell\'s contact\'s name should be "Cain"' do
    location = locations(:hell)
    assert_equal 'Cain', location.user.contact[:firstname]
  end

  test 'Heaven\'s dimension\' weight should be "9.99"' do
    location = locations(:heaven)
    assert_equal 9.99, location.dimension[:weight]
  end

  test 'Should update heaven\'s name to "Purgatory"' do
    location = locations(:heaven)
    location.update({ name: 'Purgatory' })
    assert_equal 'Purgatory', location[:name]
  end

  test 'Should delete heaven' do
    location = locations(:heaven)
    assert location.destroy
  end

end
