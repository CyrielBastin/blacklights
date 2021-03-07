class UpdateContactTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :contacts, :coordinates_id, :coordinate_id
  end
end
