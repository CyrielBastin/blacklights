# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  start_date            :datetime
#  end_date              :datetime
#  location_id           :bigint
#  price                 :decimal(10, 3)
#  registration_deadline :datetime
#  min_participant       :integer
#  max_participant       :integer
#  contact_id            :bigint
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  name                  :string(255)
#
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
    event[:name] = 'Hithere'
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
    event[:start_date] = '2051-04-21 08:41:21'
    assert_not event.save
  end

  test 'should not save an event without a price' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    assert_not event.save
  end

  test 'price should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 0

    assert_not event.save
  end

  test 'should not save an event without a registration deadline' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3

    assert_not event.save
  end

  test 'should not save an event without min participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:registration_deadline] = '2051-04-14 12:00:00'
    event[:price] = 3

    assert_not event.save
  end

  test 'min participant should be a number' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2051-04-14 12:00:00'
    event[:min_participant] = true

    assert_not event.save
  end

  test 'min participant should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2051-04-14 12:00:00'
    event[:min_participant] = 0

    assert_not event.save
  end

  test 'should not save an event without max participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2051-04-14 12:00:00'
    event[:min_participant] = 3

    assert_not event.save
  end

  test 'max participant should be a number' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2051-04-14 12:00:00'
    event[:min_participant] = 3
    event[:max_participant] = 'hello'

    assert_not event.save
  end

  test 'max participant should be higher than 0' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2051-04-14 12:00:00'
    event[:min_participant] = 3
    event[:max_participant] = 0

    assert_not event.save
  end

  test 'max participant should be higher than min participant' do
    event = Event.new
    event.location = locations(:heaven)
    event.contact = contacts(:two)
    event[:name] = events(:dark_badminton)[:name]
    event[:start_date] = '2051-04-21 08:41:21'
    event[:end_date] = '2051-05-21 18:41:21'
    event[:price] = 3
    event[:registration_deadline] = '2051-04-14 12:00:00'
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

  test 'Should add up duplicated activities' do
    event = events(:dark_volley_ball)
    event.event_activities << EventActivity.new(event_id: event.id,
                                                activity_id: activities(:basketball).id,
                                                simultaneous_activities: 3)
    event.event_activities << EventActivity.new(event_id: event.id,
                                                activity_id: activities(:basketball).id,
                                                simultaneous_activities: 7)

    assert event.save
    assert_equal 10, event.event_activities[0][:simultaneous_activities]
  end

  test 'Should add up duplicated equipment' do
    event = events(:dark_volley_ball)
    event.event_equipment << EventEquipment.new(event_id: event.id,
                                                equipment_id: equipment(:balles_de_tennis).id,
                                                quantity: 3)
    event.event_equipment << EventEquipment.new(event_id: event.id,
                                                equipment_id: equipment(:balles_de_tennis).id,
                                                quantity: 3)

    assert event.save
    assert_equal 6, event.event_equipment[0][:quantity]
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
