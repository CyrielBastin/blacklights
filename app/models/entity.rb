# == This model represents an 'Association' or group of people.
class Entity < ApplicationRecord

  belongs_to :category
  has_many :entity_users, dependent: :destroy
  has_many :entity_locations, dependent: :destroy
  has_many :entity_activities, dependent: :destroy
  has_many :entity_events, dependent: :destroy

end
