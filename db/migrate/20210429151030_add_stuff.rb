class AddStuff < ActiveRecord::Migration[6.1]
  def change

    remove_column :locations, :coordinate_id
    remove_column :suppliers, :contact_id
    add_column :activities, :public_display, :boolean
    add_column :users, :deleted_at, :datetime
    change_column :events, :price, :string
    add_column :events, :type, :string
    rename_column :categories, :category_for, :type

    change_table :suppliers do |t|
      t.string :email
      t.string :phone_number
      t.string :zip_code
      t.string :city
      t.string :country
    end

    create_table :supplier_contacts do |t|
      t.references :supplier
      t.references :contact
    end

    create_table :activity_categories do |t|
      t.references :activity
      t.references :category
    end

    create_table :event_categories do |t|
      t.references :event
      t.references :category
    end

  end
end
