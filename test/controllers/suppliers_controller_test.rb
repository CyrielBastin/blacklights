require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier = suppliers(:one)
  end

  test 'should get index' do
    get admin_suppliers_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_supplier_url
    assert_response :success
  end

  test 'should create supplier' do
    contact = contacts(:one)
    assert_difference('Supplier.count') do
      post admin_suppliers_url, params: { supplier: { name: 'Hello', contact_id: contact[:id] } }
    end

    assert_equal 'Votre fournisseur a été crée avec succès !', flash[:success]
    assert_redirected_to admin_suppliers_url
  end
  #
  # test 'should show supplier' do
  #   get supplier_url(@supplier)
  #   assert_response :success
  # end
  #
  # test 'should get edit' do
  #   get edit_supplier_url(@supplier)
  #   assert_response :success
  # end
  #
  # test 'should update supplier' do
  #   patch supplier_url(@supplier), params: { supplier: {  } }
  #   assert_redirected_to supplier_url(@supplier)
  # end
  #
  # test 'should destroy supplier' do
  #   assert_difference('Supplier.count', -1) do
  #     delete supplier_url(@supplier)
  #   end
  #
  #   assert_redirected_to suppliers_url
  # end
end
