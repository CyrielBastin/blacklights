class CreateProfile < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user
      #Individual
      t.string :firstname
      t.string :lastname

      t.string :gender
      t.date :birthdate

      #Address
      t.string :street
      t.integer :zipcode
      t.string :city
      t.string :country
      t.string :phone_number

      t.timestamps
    end
  end
end
