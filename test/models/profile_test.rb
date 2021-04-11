require "test_helper"

class ProfileTest < ActiveSupport::TestCase

  test 'should not save a profile without a gender' do
    profile = Profile.new
    profile[:user_id] = users(:cain)[:id]
    profile[:contact_id] = contacts(:one)[:id]

    assert_not profile.save
  end

  test 'should not save a profile whose gender is neither "male" nor "female"' do
    profile = Profile.new
    profile[:user_id] = users(:cain)[:id]
    profile[:contact_id] = contacts(:one)[:id]
    profile[:gender] = 'Hello'

    assert_not profile.save
  end

  test 'should not save a profile without a birthdate' do
    profile = Profile.new
    profile[:user_id] = users(:cain)[:id]
    profile[:contact_id] = contacts(:one)[:id]
    profile[:gender] = 'male'

    assert_not profile.save
  end

  test 'should not save a profile with a birthdate in the future' do
    profile = Profile.new
    profile[:user_id] = users(:cain)[:id]
    profile[:contact_id] = contacts(:one)[:id]
    profile[:gender] = 'male'
    profile[:birthdate] = Date.today + 1

    assert_not profile.save
  end

  test 'firstname for profile "cain_profile" should be "Cain"' do
    profile = profiles(:cain_profile)

    assert_equal 'Cain', profile.contact[:firstname]
  end

  test 'user_email for profile "abel_profile" should be "abel@lilbro.lamb"' do
    profile = profiles(:abel_profile)

    assert_equal 'abel@lilbro.lamb', profile.user[:email]
  end

end
