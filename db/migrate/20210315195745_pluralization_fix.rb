class PluralizationFix < ActiveRecord::Migration[6.1]
  def change
    rename_table :event_equipments, :event_equipment
    rename_table :activity_equipments, :activity_equipment
  end
end
