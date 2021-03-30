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
    supplier.contact = contacts(:one)
    assert_not supplier.save
  end

  test 'Name should be at least 4 characters long' do
    supplier = Supplier.new
    supplier.contact = contacts(:one)
    supplier[:name] = 'Bob'
    assert_not supplier.save
  end

  test 'One\'s contact\'s firstname should be Cain' do
    supplier = suppliers(:one)
    assert_equal 'Cain', supplier.contact[:firstname]
  end

  test 'Two\'s contact\'s coordinate\'s city should be Namur' do
    supplier = suppliers(:two)
    assert_equal 'Namur', supplier.contact.coordinate[:city]
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

  test 'Should delete contact then supplier' do
    supplier = suppliers(:two)
    assert supplier.contact.delete
    assert supplier.delete
  end

  test 'Should save supplier' do
    supplier = Supplier.new
    supplier[:name] = 'Consulting'
    supplier[:contact_id] = contacts(:one).id
    assert supplier.save
  end

end
