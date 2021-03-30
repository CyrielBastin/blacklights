# == Schema Information
#
# Table name: dimensions
#
#  id     :bigint           not null, primary key
#  width  :decimal(10, 3)
#  length :decimal(10, 3)
#  height :decimal(10, 3)
#  weight :decimal(10, 3)
#
require "test_helper"

class DimensionTest < ActiveSupport::TestCase

  test 'Should not save dimensions without a width' do
    dimension = Dimension.new
    assert_not dimension.save
  end

  test 'Width should be a number' do
    dimension = Dimension.new
    dimension[:width] = 'Hello'
    assert_not dimension.save
    dimension[:width] = true
    assert_not dimension.save
  end

  test 'Width should be higher than 0.00' do
    dimension = Dimension.new
    dimension[:width] = 0.00
    assert_not dimension.save
  end

  test 'Should not save dimensions without a length' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    assert_not dimension.save
  end

  test 'Length should be a number' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 'Hello'
    assert_not dimension.save
    dimension[:length] = true
    assert_not dimension.save
  end

  test 'Length should be higher than 0.00' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 0.00
    assert_not dimension.save
  end

  test 'Should not save dimensions without a height' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 5.00
    assert_not dimension.save
  end

  test 'Height should be a number' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 5.00
    dimension[:height] = 'Hello'
    assert_not dimension.save
    dimension[:height] = true
    assert_not dimension.save
  end

  test 'Height should be higher than 0.00' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 5.00
    dimension[:height] = 0.00
    assert_not dimension.save
  end

  test 'Should not save dimensions without a weight' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 5.00
    dimension[:height] = 2.34
    assert_not dimension.save
  end

  test 'Weight should be a number' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 5.00
    dimension[:height] = 2.34
    dimension[:weight] = 'Hello'
    assert_not dimension.save
    dimension[:width] = true
    assert_not dimension.save
  end

  test 'Weight should be higher than 0.00' do
    dimension = Dimension.new
    dimension[:width] = 10.1
    dimension[:length] = 5.00
    dimension[:height] = 2.34
    dimension[:weight] = 0.00
    assert_not dimension.save
  end

  test 'One\'s width' do
    dimension = dimensions(:one)
    assert_equal( 9.99, dimension[:width])
  end

  test 'Two\'s weight' do
    dimension = dimensions(:two)
    assert_equal(9.99, dimension[:weight])
  end

  test 'Should update One\'s height' do
    dimension = dimensions(:one)
    dimension.update({ height: 3.21 })
    dimension = dimensions(:one)
    assert_equal 3.21, dimension[:height]
  end

  test 'Should delete two' do
    dimension = dimensions(:two)
    assert dimension.delete
  end

end
