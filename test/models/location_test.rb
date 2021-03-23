require "test_helper"

class LocationTest < ActiveSupport::TestCase

  test 'Should not save location without a name' do
    location = Location.new
    location.contact = contacts(:one)
    location.dimension = dimensions(:one)
    assert_not location.save
  end

  test 'Location\'s name should contain at least 3 characters' do
    location = Location.new
    location.contact = contacts(:one)
    location.dimension = dimensions(:one)
    location[:name] = 'GG'
    assert_not location.save
  end

  test 'Location\'s name should be unique' do
    location = Location.new
    location.contact = contacts(:one)
    location.dimension = dimensions(:one)
    location[:name] = 'Heaven'
    assert_not location.save
  end

  test 'Should not save location without a type' do
    location = Location.new
    location.contact = contacts(:one)
    location.dimension = dimensions(:one)
    location[:name] = 'GG EZ'
    assert_not location.save
  end

  test 'Location\'s type should contain at least 7 characters' do
    location = Location.new
    location.contact = contacts(:one)
    location.dimension = dimensions(:one)
    location[:name] = 'GG EZ'
    location[:type] = '123456'
    assert_not location.save
  end

  test 'Hell\'s contact\'s name should be "Cain"' do
    location = locations(:hell)
    assert_equal 'Cain', location.contact[:firstname]
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

  test 'Should not update hell\'s name to "Heaven"' do
    location = locations(:hell)
    assert_not location.update({ name: 'Heaven' })
  end

  test 'Should delete heaven' do
    location = locations(:heaven)
    assert location.destroy
  end

end
