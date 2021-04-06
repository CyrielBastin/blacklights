class LinkProfileToContactAndMore < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, default: false

    add_column :categories, :category_for, :string

    remove_column :profiles, :firstname
    remove_column :profiles, :lastname
    remove_column :profiles, :street
    remove_column :profiles, :zipcode
    remove_column :profiles, :city
    remove_column :profiles, :country
    remove_column :profiles, :phone_number
    add_reference :profiles, :contact
  end
end
