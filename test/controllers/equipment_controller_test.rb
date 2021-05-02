require "test_helper"

class EquipmentControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipment = equipment(:balles_de_tennis)
  end

  test 'Should get index' do
    get admin_equipment_index_url

    assert_response :success
  end

  test 'Should get new' do
    get new_admin_equipment_url

    assert_response :success
  end

  test 'Should create equipment' do
    assert_difference('Equipment.count') do
      post admin_equipment_index_url, params: { equipment: {
        name: 'Jacky la louche',
        description: 'This description should be more than 20 characters',
        unit_price: 13.07,
        category_id: categories(:raquette_bad).id,
        supplier_id: suppliers(:two).id,
        dimension_attributes: {
          width: 1.11,
          length: 2.22,
          height: 3.33,
          weight: 4.44
        }
      } }
    end

    assert_equal 'Votre matériel a été crée avec succès !', flash[:success]
    assert_redirected_to admin_equipment_index_url
  end

  # test 'Should show equipment' do
  #   get admin_equipment_url(@equipment)
  #
  #   assert_response :success
  # end

  test 'Should get edit' do
    get edit_admin_equipment_url(@equipment)

    assert_response :success
  end

  test 'Should update equipment' do
    patch admin_equipment_url(@equipment), params: { equipment:
                                                       { name: 'Tournevis',
                                                         unit_price: '15,49',
                                                         category_id: "#{categories(:raquette_bad)[:id]},",
                                                         supplier_id: "#{suppliers(:two)[:id]}," } }

    assert_equal 'Votre matériel a été modifié avec succès !', flash[:success]
    assert_redirected_to admin_equipment_index_url
  end

  test 'Should destroy equipment' do
    assert_difference('Equipment.count', -1) do
      delete admin_equipment_url(@equipment)
    end

    assert_equal 'Votre matériel a été supprimé avec succès !', flash[:success]
    assert_redirected_to admin_equipment_index_url
  end

end
