# This migration exists because ActiveRecord doesn't allow a model to be named 'Association'
# Each ActiveRecord object possess a method association and would conflict with a new model name
class RenameAssociationToConsortium < ActiveRecord::Migration[6.1]
  def change

    rename_table :associations, :consortia
    rename_table :association_users, :consortium_users
    rename_table :association_locations, :consortium_locations
    rename_table :association_activities, :consortium_activities
    rename_table :association_events, :consortium_events

  end
end
