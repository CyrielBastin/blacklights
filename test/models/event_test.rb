require "test_helper"

class EventTest < ActiveSupport::TestCase

  test 'should not save an event without a start date' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    assert_not event.save
  end

  test 'should not save an event without an end date' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:start_date] = '2021-04-21 08:41:21'
    assert_not event.save
  end

  test 'should not save an event without a price' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    assert_not event.save
  end

  test 'price should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 0

    assert_not event.save
  end

  test 'should not save an event without a registration deadline' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3

    assert_not event.save
  end

  test 'should not save an event without min participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
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
    event[:start_date] = '2021-04-21 08:41:21'
    event[:end_date] = '2021-05-21 08:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2021-05-14 12:00:00'
    event[:min_participant] = 3
    event[:max_participant] = 5

    assert event[:max_participant] > event[:min_participant]
  end

end
