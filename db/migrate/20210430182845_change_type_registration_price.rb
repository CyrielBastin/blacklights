class ChangeTypeRegistrationPrice < ActiveRecord::Migration[6.1]
  def change

    change_column :registrations, :price, :string

  end
end
