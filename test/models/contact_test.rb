require "test_helper"

class ContactTest < ActiveSupport::TestCase

  test 'Should not save contact without a lastname' do
    contact = Contact.new
    assert_not contact.save
  end

  test 'Lastname should have at least 3 characters' do
    contact = Contact.new
    contact[:lastname] = 'Hi'
    assert_not contact.save
  end

  test 'Should not save contact without a firstname' do
    contact = Contact.new
    contact[:lastname] = 'Smith'
    assert_not contact.save
  end

  test 'Firstname should have at least 3 characters' do
    contact = Contact.new
    contact[:lastname] = 'Smith'
    contact[:firstname] = 'Hi'
    assert_not contact.save
  end

  test 'Should not save contact without a phone number' do
    contact = Contact.new
    contact[:lastname] = 'Smith'
    contact[:firstname] = 'John'
    assert_not contact.save
  end

  test 'Phone number should have at least 10 characters' do
    contact = Contact.new
    contact[:lastname] = 'Smith'
    contact[:firstname] = 'John'
    contact[:phone_number] = '123456789'  # 9 chars
    assert_not contact.save
  end

  test 'Should not save contact without an email' do
    contact = Contact.new
    contact[:lastname] = 'Smith'
    contact[:firstname] = 'John'
    contact[:phone_number] = '0123456789'
    assert_not contact.save
  end

  test 'Email should be valid' do
    contact = Contact.new
    contact[:lastname] = 'Smith'
    contact[:firstname] = 'John'
    contact[:phone_number] = '0123456789'
    contact.coordinate_id = coordinates(:cain).id
    #
    contact[:email] = 'blah'
    assert_not contact.save
    #
    contact[:email] = 123
    assert_not contact.save
    #
    contact[:email] = '@hello.world'
    assert_not contact.save
    #
    contact[:email] = 'hello@world.com'
    assert contact.save
  end

  test 'One\'s lastname' do
    contact = contacts(:one)
    assert_equal 'Edengarden', contact[:lastname]
  end

  test 'Should update two\'s firstname' do
    contact = contacts(:two)
    assert contact.update({ firstname: 'Jacky' })
    assert_equal 'Jacky', contact[:firstname]
  end

  test 'Should delete two' do
    contact = contacts(:two)
    assert contact.delete
  end

  test 'Should get one\'s city' do
    contact = contacts(:one)
    assert_equal 'Brussels', contact.coordinate[:city]
  end

  test 'Should get two\'s street' do
    contact = contacts(:two)
    assert_equal 'Lamb\'s street, 2', contact.coordinate[:street]
  end

  test 'Should get supplier\'s name from one' do
    contact = contacts(:one)
    assert_equal 'ABC_Agency', contact.supplier[:name]
  end

end
