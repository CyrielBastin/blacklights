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
    coordinate = Coordinate.new(street: 'This is my street',
                                zip_code: 1111,
                                city: 'My city',
                                country: 'Welcome to the country')
    contact = Contact.new(lastname: 'Lastname',
                          firstname: 'Firstname',
                          phone_number: '0111/11.11.11',
                          email: 'hello@world.net')
    supplier = Supplier.new(name: 'New_supplier')

    assert_difference('Supplier.count') do
      post admin_suppliers_url, params: { supplier: supplier, contact: contact, coordinate: coordinate }
    end

    assert_equal 'Votre fournisseur a été crée avec succès !', flash[:success]
    assert_redirected_to admin_suppliers_url
  end

  test 'Should show supplier' do
    get admin_supplier_url(@supplier)
    assert_response :success
  end

  test 'Should get edit' do
    get edit_admin_supplier_url(@supplier)
    assert_response :success
  end
  #
  # test 'should update supplier' do
  #   patch supplier_url(@supplier), params: { supplier: {  } }
  #   assert_redirected_to supplier_url(@supplier)
  # end

  # test 'Should destroy supplier' do
  #   assert_difference('Supplier.count', -1) do
  #     delete admin_supplier_url(@supplier)
  #   end
  #
  #   assert_equal 'Votre fournisseur a été supprimé avec succès !', flash[:success]
  #   assert_redirected_to admin_suppliers_url
  # end

end
