# == Schema Information
#
# Table name: activities
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class ActivityTest < ActiveSupport::TestCase

  test 'Should not save activity without a name' do
    activity = Activity.new
    activity.category = categories(:bizutage)

    assert_not activity.save
  end

  test 'Name should contain at least 4 characters' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'one'

    assert_not activity.save
  end

  test 'should not save an activity with \'&\' in name' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'Hello & World'

    assert_not activity.save
  end

  test 'should not save an activity with \'+\' in name' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'Hello + World'

    assert_not activity.save
  end

  test 'should not save an activity with \'(\' in name' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'Hello ( World'

    assert_not activity.save
  end

  test 'should not save an activity with \')\' in name' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'Hello ) World'

    assert_not activity.save
  end

  test 'Should not save activity without a description' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'Badminton'

    assert_not activity.save
  end

  test 'Description should contain at least 10 characters' do
    activity = Activity.new
    activity.category = categories(:bizutage)
    activity[:name] = 'Four'
    activity[:description] = 'This is a'  # 9 chars

    assert_not activity.save
  end

  test 'Badminton\'s name' do
    activity = activities(:badminton)

    assert_equal('Badminton', activity[:name])
  end

  test 'Basketball\'s description' do
    activity = activities(:basketball)

    assert_equal 'Le basketball, ça étonne!', activity[:description]
  end

  test 'Should add up duplicated equipment' do
    activity = activities(:basketball)
    activity.activity_equipment << ActivityEquipment.new(activity_id: activity.id, equipment_id: equipment(:balles_de_tennis).id, quantity: 2)
    activity.activity_equipment << ActivityEquipment.new(activity_id: activity.id, equipment_id: equipment(:balles_de_tennis).id, quantity: 3)

    assert activity.save
    assert_equal 5, activity.activity_equipment[0][:quantity]
  end

  test 'Should update Badminton\'s name' do
    activity = activities(:badminton)
    assert activity.update({ name: 'Climbing' })
    activity = activities(:badminton)

    assert_equal 'Climbing', activity[:name]
  end

  test 'Should delete Badminton' do
    activity = activities(:badminton)

    assert activity.delete
  end

end
