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

  # test 'should create event' do
  #   assert_difference('Event.count') do
  #     post admin_events_url, params: { event: {  } }
  #   end
  #
  #   assert_equal 'Votre évènement a été crée avec succès !', flash[:success]
  #   assert_redirected_to admin_events_url
  # end

  # test 'should show event' do
  #   get admin_event_url(@event)
  #   assert_response :success
  # end

  test 'should get edit' do
    get edit_admin_event_url(@event)
    assert_response :success
  end

  test 'should update event' do
    patch admin_event_url(@event), params: { event: { min_participant: 5 } }

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
