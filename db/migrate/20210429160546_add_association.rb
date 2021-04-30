class AddAssociation < ActiveRecord::Migration[6.1]
  def change

    create_table :associations do |t|
      t.string :name
      t.references :category
    end

    create_table :association_users do |t|
      t.references :association
      t.references :user
    end

    create_table :association_locations do |t|
      t.references :association
      t.references :location
    end

    create_table :association_activities do |t|
      t.references :association
      t.references :activity
    end

    create_table :association_events do |t|
      t.references :association
      t.references :event
    end

  end
end
