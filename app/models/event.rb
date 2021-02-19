class Event < ApplicationRecord

  belongs_to :location
  belongs_to :contact
  has_many :event_activities
  has_many :registrations
  has_many :event_activity_equipments

end
