class Activity < ApplicationRecord

  has_many :event_activities
  has_many :location_activities
  has_many :event_activity_equipments

  validates :name, presence: true, length: { minimum: 4, maximum: 30 }, uniqueness: true
  validates :description, presence: true, length: { minimum: 15 }

end
