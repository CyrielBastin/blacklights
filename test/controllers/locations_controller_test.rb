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

  test 'Should create location' do
    assert_difference('Location.count') do
      post admin_locations_url, params:
        { location:
            { name: 'Superb Hall',
              type: 'Outdoors',
              contact_attributes:
                { lastname: 'Lalouche',
                  firstname: 'Jacky',
                  phone_number: '0411/11.11.11',
                  email: 'jacky@lalouche.net',
                  coordinate_attributes:
                    { street: 'Rue du Manouche, 11',
                      zip_code: 1000,
                      city: 'Bruxelles',
                      country: 'Belgique' } },
              dimension_attributes:
                { width: 1.11,
                  length: 2.22,
                  height: 3.33,
                  weight: 4.44 },
              location_activity_ids: [ activities(:badminton)[:id] ] } }
    end

    assert_equal 'Votre lieu a été crée avec succès !', flash[:success]
    assert_redirected_to admin_locations_url
  end

  # test 'Should show location' do
  #   get admin_location_url(@location)
  #   assert_response :success
  # end

  test 'Should get edit' do
    get edit_admin_location_url(@location)
    assert_response :success
  end

  test 'Should update location' do
    patch admin_location_url(@location), params:
      { location:
          { name: 'Has been patched',
            location_activity_ids: [ activities(:badminton)[:id] ] } }

    assert_equal 'Votre lieu a été modifié avec succès !', flash[:success]
    assert_redirected_to admin_locations_url
  end

  test 'Should destroy location' do
    assert_difference('Location.count', -1) do
      delete admin_location_url(@location)
    end

    assert_equal 'Votre lieu a été supprimé avec succès !', flash[:success]
    assert_redirected_to admin_locations_url
  end

end
