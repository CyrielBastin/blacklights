class FieldVisibleToActivity < ActiveRecord::Migration[6.1]
  def change

    rename_column :activities, :public_display, :visible

  end
end
