class ChangeConsortiumAndSupplierLink < ActiveRecord::Migration[6.1]
  def change

    remove_column :supplier_contacts, :contact_id
    rename_table :supplier_contacts, :supplier_users
    add_reference :supplier_users, :user

    drop_table :consortium_users
    drop_table :consortium_locations
    drop_table :consortium_activities
    drop_table :consortium_events
    drop_table :consortia

    create_table :entities do |t|
      t.string :name
      t.references :category
    end

    create_table :entity_users do |t|
      t.references :entity
      t.references :user
    end

    create_table :entity_locations do |t|
      t.references :entity
      t.references :location
    end

    create_table :entity_activities do |t|
      t.references :entity
      t.references :activity
    end

    create_table :entity_events do |t|
      t.references :entity
      t.references :event
    end

  end
end
