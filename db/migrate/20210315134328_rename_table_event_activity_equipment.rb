class RenameTableEventActivityEquipment < ActiveRecord::Migration[6.1]
  def change
    rename_table :event_activity_equipments, :event_equipments
    remove_column :event_equipments, :activity_id
    add_column :event_activities, :simultaneous_activities, :integer
  end
end
