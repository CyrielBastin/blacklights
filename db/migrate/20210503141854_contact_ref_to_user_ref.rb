class ContactRefToUserRef < ActiveRecord::Migration[6.1]
  def change

    remove_column :locations, :contact_id
    remove_column :events, :contact_id

    add_reference :locations, :user
    add_reference :events, :user

  end
end
