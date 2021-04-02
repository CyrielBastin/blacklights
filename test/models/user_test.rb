require "test_helper"

class UserTest < ActiveSupport::TestCase

  test 'should not save a user without an email' do
    user = User.new

    assert_not user.save
  end

  test 'should not save a user without a valid email' do
    user = User.new
    user[:email] = 'Not_working'

    assert_not user.save
  end

  test 'should save fixture "cain"' do
    assert users(:cain).save
  end

  test 'birthdate for profile "cain_profile" should be "1212-12-12"' do
    user = users(:cain)

    assert_equal '1212-12-12', user.profile[:birthdate].to_s
  end

  test 'street for profile "abel_profile" should be "Lamb\'s street, 2"' do
    user = users(:abel)

    assert_equal 'Lamb\'s street, 2', user.profile.contact.coordinate[:street]
  end

end
