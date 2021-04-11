require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration = registrations(:cain_dark_badminton)
  end

  test 'should get index' do
    get admin_registrations_url

    assert_response :success
  end

  test 'should get new' do
    get new_admin_registration_url

    assert_response :success
  end

  test 'should create registration' do
    assert_difference('Registration.count') do
      post admin_registrations_url, params: { registration: {
        event_id: events(:dark_badminton)[:id],
        user_id: users(:cain)[:id],
        price: 99.99,
        confirmation_datetime: nil,
        payment_confirmation_datetime: nil
      } }
    end

    assert_equal 'Votre réservation a été créée avec succès !', flash[:success]
    assert_redirected_to admin_registrations_url
  end

  # test 'should show registration' do
  #   get admin_registration_url(@registration)
  #
  #   assert_response :success
  # end

  test 'should get edit' do
    get edit_admin_registration_url(@registration)

    assert_response :success
  end

  test 'should update registration' do
    patch admin_registration_url(@registration), params: { registration: {
      confirmation_datetime: '2021-04-02 12:12:12',
      payment_confirmation_datetime: '2021-04-02 13:13:13'
    } }

    assert_equal 'Votre réservation a été modifiée avec succès !', flash[:success]
    assert_redirected_to admin_registrations_url
  end

  test 'should destroy registration' do
    assert_difference('Registration.count', -1) do
      delete admin_registration_url(@registration)
    end

    assert_equal 'Votre réservation a été supprimée avec succès !', flash[:success]
    assert_redirected_to admin_registrations_url
  end

end
