require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:raquettes)
  end

  test 'Should get index' do
    get admin_categories_url
    assert_response :success
  end

  test 'Should get new' do
    get new_admin_category_url
    assert_response :success
  end

  test 'Should create category' do
    assert_difference('Category.count') do
      post admin_categories_url, params: { category: { name: 'Fridgette', parent_id: '', category_for: 'Matériel' } }
    end

    assert_equal 'Votre catégorie a été créée avec succès !', flash[:success]
    assert_redirected_to admin_categories_url
  end

  # test 'Should show category' do
  #   get admin_category_url(@category)
  #   assert_response :success
  # end

  test 'Should get edit' do
    get edit_admin_category_url(@category)
    assert_response :success
  end

  test 'Should update category' do
    patch admin_category_url(@category), params: { category: { name: 'Biggu', parent_id: '' } }
    assert_redirected_to admin_categories_url
  end

  test 'Should destroy category' do
    assert_difference('Category.count', -1) do
      delete admin_category_url(@category)
    end

    assert_redirected_to admin_categories_url
  end

end
