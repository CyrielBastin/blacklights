class RemoveActivityCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :category_id, :integer, after: :description
    add_column :events, :category_id, :integer, after: :contact_id

    drop_table :activity_categories
    drop_table :event_activities
  end
end
