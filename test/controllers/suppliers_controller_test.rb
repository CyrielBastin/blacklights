require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier = suppliers(:one)
  end

  test 'Should get index' do
    get admin_suppliers_url
    assert_response :success
  end

  test 'Should get new' do
    get new_admin_supplier_url
    assert_response :success
  end

  test 'Should create supplier' do
    assert_difference('Supplier.count') do
      post admin_suppliers_url, params:
        { supplier:
          { name: 'Brand_new_supplier',
            email: 'superemail@email.com',
            phone_number: '01 02 03 04 05',
            country: 'Belgique',
            supplier_user_ids: '' },
          creating_new_user: '1',
          user_admin: 'on',
          user: {
              email: 'jacky@lalouche.net',
              skip_password_validation: 'true',
              profile_attributes: {
                gender: 'male',
                contact_attributes:
                  { lastname: 'Lalouche',
                    firstname: 'Jacky',
                    phone_number: '0411/11.11.11',
                    email: 'jacky@lalouche.net' } } } }
    end

    assert_equal 'Votre fournisseur a été crée avec succès !', flash[:success]
    assert_redirected_to admin_suppliers_url
  end

  # test 'Should show supplier' do
  #   get admin_supplier_url(@supplier)
  #   assert_response :success
  # end

  test 'Should get edit' do
    get edit_admin_supplier_url(@supplier)
    assert_response :success
  end

  test 'Should update supplier' do
    patch admin_supplier_url(@supplier), params: { supplier: { name: 'New_name', email: 'djapojda@djao.c',
                                                               phone_number: '123456789', country: 'France',
                                                               supplier_user_ids: '' },
                                                   creating_new_user: '1',
                                                   user: {
                                                     email: 'jacky@lalouche.net',
                                                     skip_password_validation: 'true',
                                                     profile_attributes: {
                                                       gender: 'male',
                                                       contact_attributes:
                                                         { lastname: 'Lalouche',
                                                           firstname: 'Jacky',
                                                           phone_number: '0411/11.11.11',
                                                           email: 'jacky@lalouche.net' } } } }
    assert_equal 'Votre fournisseur a été modifié avec succès !', flash[:success]
    assert_redirected_to admin_suppliers_url
  end

  test 'Should destroy supplier' do
    assert_difference('Supplier.count', -1) do
      delete admin_supplier_url(@supplier)
    end

    assert_equal 'Votre fournisseur a été supprimé avec succès !', flash[:success]
    assert_redirected_to admin_suppliers_url
  end

end
