require "test_helper"

class RegistrationTest < ActiveSupport::TestCase

  test 'should not save a registration without a price' do
    registration = Registration.new
    registration[:user_id] = users(:cain)[:id]
    registration[:event_id] = events(:dark_badminton)[:id]

    assert_not registration.save
  end

  test '"price" should be a number' do
    registration = Registration.new
    registration[:user_id] = users(:cain)[:id]
    registration[:event_id] = events(:dark_badminton)[:id]
    registration[:price] = 'Not a number'

    assert_not registration.save
  end

  test '"price" should be higher than "0.00"' do
    registration = Registration.new
    registration[:user_id] = users(:cain)[:id]
    registration[:event_id] = events(:dark_badminton)[:id]
    registration[:price] = 0.00

    assert_not registration.save
  end

  test '"confirmation_datetime" cannot be in the future' do
    registration = Registration.new
    registration[:user_id] = users(:cain)[:id]
    registration[:event_id] = events(:dark_badminton)[:id]
    registration[:price] = 0.01
    registration[:confirmation_datetime] = DateTime.now + 1

    assert_not registration.save
  end

  test '"payment_confirmation_datetime" cannot be in the future' do
    registration = Registration.new
    registration[:user_id] = users(:cain)[:id]
    registration[:event_id] = events(:dark_badminton)[:id]
    registration[:price] = 0.01
    registration[:confirmation_datetime] = DateTime.now
    registration[:payment_confirmation_datetime] = DateTime.now + 1

    assert_not registration.save
  end

end
