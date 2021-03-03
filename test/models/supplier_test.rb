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

  # Add update and remove test

end
