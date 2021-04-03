class ProfileContactFk < ActiveRecord::Migration[6.1]
  def change
    remove_column :profiles, :contact_id

    add_reference :profiles, :contact
  end
end
