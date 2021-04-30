# == This model represents an 'Association' or group of people.
class Consortium < ApplicationRecord

  belongs_to :category
  has_many :consortium_users, dependent: :destroy
  has_many :consortium_locations, dependent: :destroy
  has_many :consortium_activities, dependent: :destroy
  has_many :consortium_events, dependent: :destroy

end
