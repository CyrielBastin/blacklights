require "test_helper"

class EquipmentTest < ActiveSupport::TestCase

  test 'Should not save equipment without a name' do
    equipment = Equipment.new
    assert_not equipment.save
  end

end
