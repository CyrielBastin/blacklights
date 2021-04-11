require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:cain)
  end

  test 'should get index' do
    get admin_users_url

    assert_response :success
  end

  test 'should get new' do
    get new_admin_user_url

    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post admin_users_url, params: { user: {
        email: 'dummy@email.com',
        'skip_password_validation': true,
        profile_attributes: {
          gender: 'female',
          'birthdate(1i)': 1912,
          'birthdate(2i)': 12,
          'birthdate(3i)': 12,
          contact_attributes: {
            lastname: 'Lalouche',
            firstname: 'Jacky',
            phone_number: '0411/11.11.11',
            email: 'dummy@email.com',
            coordinate_attributes: {
              street: 'Grand Rue, 13',
              zip_code: 1111,
              city: 'Bruxelles',
              country: 'Belgique'
            }
          }
        }
      } }
    end

    assert_redirected_to admin_users_url
  end

  # test 'should show user' do
  #   get user_url(@user)
  #   assert_response :success
  # end

  test 'should get edit' do
    get edit_admin_user_url(@user)

    assert_response :success
  end

  test 'should update user' do
    patch admin_user_url(@user), params: { user: {
      email: 'dadada@dazda.dz',
      'skip_password_validation': true
    } }

    assert_redirected_to admin_users_url
  end

  # test 'should destroy user' do
  #   assert_difference('User.count', -1) do
  #     delete user_url(@user)
  #   end
  #
  #   assert_redirected_to users_url
  # end
end
