require "test_helper"

class ActivityTest < ActiveSupport::TestCase

  test "Should not save activity without a name" do
    activity = Activity.new
    assert_not activity.save
  end

  test "Should not save activity without a description" do
    activity = Activity.new
    activity.name = "Badminton"
    assert_not activity.save
  end

  test "Name should contain at least 4 characters" do
    activity = Activity.new
    activity.name = "one"
    activity.description = "This is a description !!!"
    assert_not activity.save
  end

  test "Description should contain at least 15 characters" do
    activity = Activity.new
    activity.name = "Four"
    activity.description = "This is a desc"  # 14 chars
    assert_not activity.save
  end

  test "Badminton's name" do
    activity = activities(:badminton)
    assert_equal("Badminton", activity.name)
  end

  test "Basketball's description" do
    activity = activities(:basketball)
    assert_equal "Le basketball, ça étonne!", activity.description
  end

end
