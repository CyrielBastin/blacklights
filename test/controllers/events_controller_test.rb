require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:dark_badminton)
  end

  test 'should get index' do
    get admin_events_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_event_url
    assert_response :success
  end

  test 'should create event' do
    assert_difference('Event.count') do
      post admin_events_url, params:
        { event:
            { name: 'Merguez Party',
              start_date: '2051-05-21 08:45:21',
              # 'start_date(3i)': '21',
              # 'start_date(2i)': '05',
              # 'start_date(1i)': '2051',
              # 'start_date(4i)': '08',
              # 'start_date(5i)': '45',
              end_date: '2051-05-21 18:45:21',
              registration_deadline: '2051-04-21 08:45:22',
              price: 99.99,
              min_participant: 7,
              max_participant: 9,
              location_id: locations(:heaven).id,
              type: '1',
              user_attributes: {
                email: 'jacky@lalouche.net',
                admin: '0',
                skip_password_validation: 'true',
                profile_attributes: {
                  gender: 'male',
                  contact_attributes:
                    { lastname: 'Lalouche',
                      firstname: 'Jacky',
                      phone_number: '0411/11.11.11',
                      email: 'jacky@lalouche.net',
                      coordinate_attributes:
                        { street: 'Rue du Manouche, 11',
                          zip_code: 1000,
                          city: 'Bruxelles',
                          country: 'Belgique' } }
                }
              },
              activity_equipment_attributes: { '0': {
                equipment_id: equipment(:raquette_de_badminton).id,
                quantity: 5 } },
              event_equipment_ids: '' } }
    end

    assert_equal 'Votre évènement a été crée avec succès !', flash[:success]
    assert_redirected_to admin_events_url
  end

  test 'should show event' do
    get admin_event_url(@event)
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_event_url(@event)
    assert_response :success
  end

  test 'should update event' do
    patch admin_event_url(@event), params: { event:
                                               { min_participant: 5,
                                                 location_id: "#{locations(:heaven)[:id]},",
                                                 event_equipment_ids: '',
                                                 type: '0' } }

    assert_equal 'Votre évènement a été modifié avec succès !', flash[:success]
    assert_redirected_to admin_events_url
  end

  test 'should destroy event' do
    assert_difference('Event.count', -1) do
      delete admin_event_url(@event)
    end

    assert_equal 'Votre évènement a été supprimé avec succès !', flash[:success]
    assert_redirected_to admin_events_url
  end
end
