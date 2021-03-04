require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:heaven)
  end

  test 'Should get index' do
    get admin_locations_url
    assert_response :success
  end

  test 'Should get new' do
    get new_admin_location_url
    assert_response :success
  end

  # test 'Should create location' do
  #   assert_difference('Location.count') do
  #     post admin_locations_url, params: { location: {  } }
  #   end
  #
  #   assert_redirected_to location_url(Location.last)
  # end

  test 'Should show location' do
    get admin_location_url(@location)
    assert_response :success
  end

  test 'Should get edit' do
    get edit_admin_location_url(@location)
    assert_response :success
  end

  test 'Should update location' do
    patch admin_location_url(@location), params: { location: { name: 'Has been patched' } }
    assert_equal 'Votre location a été modifiée avec succès !', flash[:success]
    assert_redirected_to admin_locations_url
  end

  test 'Should destroy location' do
    assert_difference('Location.count', -1) do
      delete admin_location_url(@location)
    end

    assert_redirected_to admin_locations_url
  end

end
