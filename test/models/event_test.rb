require "test_helper"

class EventTest < ActiveSupport::TestCase

  test 'should not save an event without a name' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    assert_not event.save
  end

  test 'name should contain at least 8 characters' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = '1234567'
    assert_not event.save
  end

  test 'should not save an event without a start date' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    assert_not event.save
  end

  test 'should not save an event without an end date' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    assert_not event.save
  end

  test 'should not save an event without a price' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    assert_not event.save
  end

  test 'price should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 0

    assert_not event.save
  end

  test 'should not save an event without a registration deadline' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3

    assert_not event.save
  end

  test 'should not save an event without min participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'

    assert_not event.save
  end

  test 'min participant should be a number' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = true

    assert_not event.save
  end

  test 'min participant should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = 0

    assert_not event.save
  end

  test 'should not save an event without max participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = 3

    assert_not event.save
  end

  test 'max participant should be a number' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = 3
    event[:max_participant] = 'hello'

    assert_not event.save
  end

  test 'max participant should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = 3
    event[:max_participant] = 0

    assert_not event.save
  end

  test 'max participant should be higher than min participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = 3
    event[:max_participant] = 5

    assert event[:max_participant] > event[:min_participant]
  end

  test 'contact\'s firstname for event "dark_badminton" should be "Cain"' do
    event = events(:dark_badminton)

    assert_equal 'Cain', event.contact[:firstname]
  end

  test 'location\'s name for event "dark_volley_ball" should be "Hell"' do
    event = events(:dark_volley_ball)

    assert_equal 'Hell', event.location[:name]
  end

  test 'should update min_participant to "5"' do
    event = events(:dark_badminton)
    assert event.update({ min_participant: 5 })

    assert_equal 5, event[:min_participant]
  end

  test 'should delete event "dark_badminton"' do
    event = events(:dark_badminton)

    assert event.destroy
  end

end
