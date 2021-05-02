require "test_helper"

class EntityTest < ActiveSupport::TestCase

  test 'should not save an entity without a category' do
    entity = Entity.new

    assert_not entity.save
  end

  test 'should not save an entity without a name' do
    entity = Entity.new do |e|
      e.category = categories(:bizutage)
    end

    assert_not entity.save
  end

  test 'should not save an entity whose name already exists' do
    entity = Entity.new do |e|
      e.category = categories(:bizutage)
      e[:name] = entities(:arc_en_ciel)[:name]
    end

    assert_not entity.save
  end

end
