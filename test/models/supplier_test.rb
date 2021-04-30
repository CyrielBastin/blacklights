# == Schema Information
#
# Table name: suppliers
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  contact_id :bigint
#
require "test_helper"

class SupplierTest < ActiveSupport::TestCase

  test 'Sould not save supplier without a name' do
    supplier = Supplier.new

    assert_not supplier.save
  end

  test 'Name should be at least 3 characters long' do
    supplier = Supplier.new
    supplier[:name] = 'GG'

    assert_not supplier.save
  end

  test 'name cannot contain character \'&\'' do
    supplier = Supplier.new
    supplier[:name] = 'gg&ez'

    assert_not supplier.save
  end

  test 'should not save a supplier without an email' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'

    assert_not supplier.save
  end

  test 'should not save a supplier without a correct email' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'
    supplier[:email] = 'marcel.picard@free'

    assert_not supplier.save
  end

  test 'should not save a supplier with \'&\' in email' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'
    supplier[:email] = 'sup&sup@free.fr'

    assert_not supplier.save
  end

  test 'should not save a supplier without a phone number' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'
    supplier[:email] = 'sup.sup@free.fr'

    assert_not supplier.save
  end

  test 'should not save a supplier with \'&\' in phone number' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'
    supplier[:email] = 'sup.sup@free.fr'
    supplier[:phone_number] = '06 05 04 & 03 02'

    assert_not supplier.save
  end

  test 'should not save a supplier without a country' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'
    supplier[:email] = 'sup.sup@free.fr'
    supplier[:phone_number] = '06 05 04 03 02'

    assert_not supplier.save
  end

  test 'should not save a supplier with \'&\' in country' do
    supplier = Supplier.new
    supplier[:name] = 'supsup'
    supplier[:email] = 'sup.sup@free.fr'
    supplier[:phone_number] = '06 05 04 03 02'
    supplier[:country] = '&France'

    assert_not supplier.save
  end

  test 'Should update one\'s name to "Hello"' do
    supplier = suppliers(:one)
    assert supplier.update({ name: 'Hello' })

    assert_equal 'Hello', supplier[:name]
  end

  test 'Should delete two' do
    supplier = suppliers(:two)

    assert supplier.delete
  end

  test 'Should save supplier' do
    supplier = Supplier.new
    supplier[:name] = 'Consulting'
    supplier[:email] = 'marcel.picard@gmail.com'
    supplier[:phone_number] = '0498/45.64.30'
    supplier[:country] = 'Belgique'

    assert supplier.save
  end

end
