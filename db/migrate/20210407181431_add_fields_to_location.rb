class AddFieldsToLocation < ActiveRecord::Migration[6.1]
  def change
    change_table :locations do |t|
      t.integer :capacity
      t.string :street
      t.integer :zip_code
      t.string :city
      t.string :country
    end
  end
end
