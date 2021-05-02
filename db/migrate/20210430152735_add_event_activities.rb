class AddEventActivities < ActiveRecord::Migration[6.1]
  def change

    drop_table :event_categories

    create_table :event_activities do |t|
      t.references :event
      t.references :activity
      t.integer :quantity
    end

  end
end
