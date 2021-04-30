require "test_helper"

class EntitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity = entities(:les_bienfaiteurs)
  end

  test 'should get index' do
    get admin_entities_url

    assert_response :success
  end

  test 'should get new' do
    get new_admin_entity_url

    assert_response :success
  end

  test 'should create entity' do
    assert_difference('Entity.count') do
      post admin_entities_url, params: { entity: { name: 'Les Cafards de Kafka',
                                                   category_id: "#{categories(:bizutage)[:id]},",
                                                   entity_user_ids: '',
                                                   entity_location_ids: '',
                                                   entity_activity_ids: '',
                                                   entity_event_ids: '' } }
    end

    assert_equal 'Votre association a été créée avec succès !', flash[:success]
    assert_redirected_to admin_entities_url
  end

  test 'should show entity' do
    get admin_entity_url(@entity)

    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_entity_url(@entity)

    assert_response :success
  end

  test 'should update entity' do
    patch admin_entity_url(@entity), params: { entity: { category_id: "#{categories(:bizutage)[:id]},",
                                                         entity_user_ids: "#{users(:cain)[:id]},#{users(:abel)[:id]},",
                                                         entity_location_ids: '',
                                                         entity_activity_ids: '',
                                                         entity_event_ids: "#{events(:dark_badminton)[:id]}," } }

    assert_equal 'Votre association a été modifiée avec succès !', flash[:success]
    assert_redirected_to admin_entities_url
  end

  test 'should destroy entity' do
    assert_difference('Entity.count', -1) do
      delete admin_entity_url(@entity)
    end

    assert_equal 'Votre association a été supprimée avec succès !', flash[:success]
    assert_redirected_to admin_entities_url
  end
end
