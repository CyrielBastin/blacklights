class Activity < ApplicationRecord

  has_many :event_activities
  has_many :location_activities
  has_many :event_activity_equipments

end
