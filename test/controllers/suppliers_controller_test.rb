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
            contact_attributes:
              { lastname: 'Lastname',
                firstname: 'Firstname',
                phone_number: '0111/11.11.11',
                email: 'hello@world.net',
                coordinate_attributes:
                  { street: 'Best street ever, 123',
                    zip_code: 1111,
                    city: 'My city',
                    country: 'Welcome to the country' } } } }
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
    patch admin_supplier_url(@supplier), params: { supplier: { name: 'New_name' } }
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
