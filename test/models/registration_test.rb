require "test_helper"

class RegistrationTest < ActiveSupport::TestCase

  test 'should not save a registration without an event' do
    registration = Registration.new

    assert_not registration.save
  end

  test 'should not save a registration without a user' do
    registration = Registration.new
    registration.event = events(:dark_badminton)

    assert_not registration.save
  end

  test 'should not save a registration without a price' do
    registration = Registration.new
    registration.user = users(:cain)
    registration.event = events(:dark_badminton)

    assert_not registration.save
  end

  test 'should update registration price to "Gratuit"' do
    registration = registrations(:cain_dark_badminton)
    registration[:price] = 'Gratuit'
    assert registration.save
    registration = registrations(:cain_dark_badminton)

    assert_equal 'Gratuit', registration[:price]
  end

  test 'should delete registration' do
    registration = registrations(:cain_dark_badminton)

    assert registration.delete
  end

end
