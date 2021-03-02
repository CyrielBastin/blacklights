class CreateModels < ActiveRecord::Migration[6.1]
  def change

    create_table :coordinates do |t|
      t.string :street
      t.integer :zip_code
      t.string :city
      t.string :country
    end

    create_table :contacts do |t|
      t.string :lastname
      t.string :firstname
      t.string :phone_number
      t.string :email
      t.references :coordinate
    end

    create_table :dimensions do |t|
      t.decimal :width, precision: 10, scale: 3
      t.decimal :length, precision: 10, scale: 3
      t.decimal :height, precision: 10, scale: 3
      t.decimal :weight, precision: 10, scale: 3
    end

    create_table :suppliers do |t|
      t.string :name
      t.references :contact
    end

    create_table :activities do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :activity_equipments do |t|
      t.references :activity
      t.references :equipment
      t.decimal :quantity, precision: 10, scale: 3
      t.timestamps
    end

    create_table :categories do |t|
      t.string :name
      t.references :parent, reference: :category
    end

    create_table :equipment do |t|
      t.string :name
      t.text :description
      t.references :category
      t.references :supplier
      t.references :dimension
      t.decimal :unit_price, precision: 10, scale: 3
    end

    create_table :locations do |t|
      t.string :name
      t.string :type
      t.references :contact
      t.references :coordinate
      t.references :dimension
      t.timestamps
    end

    create_table :location_activities do |t|
      t.references :location
      t.references :activity
    end

    create_table :events do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.references :location
      t.decimal :price, precision: 10, scale: 3
      t.datetime :registration_deadline
      t.integer :min_participant
      t.integer :max_participant
      t.references :contact
      t.timestamps
    end

    create_table :event_activities do |t|
      t.references :event
      t.references :activity
    end

    create_table :registrations do |t|
      t.references :event
      t.references :user
      t.decimal :price, precision: 10, scale: 3
      t.datetime :confirmation_datetime
      t.datetime :payment_confirmation_datetime
      t.timestamps
    end

    create_table :event_activity_equipments do |t|
      t.references :event
      t.references :activity
      t.references :equipment
      t.decimal :quantity, precision: 10, scale: 3
    end

  end
end
