require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity = activities(:badminton)
  end

  test 'should get index' do
    get admin_activities_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_activity_url
    assert_response :success
  end

  test 'should create activity' do
    assert_difference('Activity.count') do
      post admin_activities_url, params:
        { activity:
            { name: 'Climbing',
              description: 'Climbing is wholesome!',
              location_activity_ids:
                [ locations(:heaven)[:id],
                  locations(:hell)[:id] ] } }
    end

    assert_equal 'Votre activité a été créée avec succès !', flash[:success]
    assert_redirected_to admin_activities_url
  end

  # test 'should show activity' do
  #   get admin_activity_url(@activity)
  #   assert_response :success
  # end

  test 'should get edit' do
    get edit_admin_activity_url(@activity)
    assert_response :success
  end

  test 'should update activity' do
    patch admin_activity_url(@activity), params:
      { activity:
          { name: 'Climbing',
            location_activity_ids:
              [ locations(:heaven).id ] } }
    assert_equal 'Votre activité a été modifiée avec succès !', flash[:success]
    assert_redirected_to admin_activities_url
  end

  test 'should destroy activity' do
    assert_difference('Activity.count', -1) do
      delete admin_activity_url(@activity)
    end

    assert_equal 'Votre activité a été supprimée avec succès.', flash[:success]
    assert_redirected_to admin_activities_url
  end
end
