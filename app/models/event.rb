class Event < ApplicationRecord

  belongs_to :location
  belongs_to :contact
  has_many :event_activities
  has_many :registrations
  has_many :event_activity_equipments

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :price, presence: true, numericality: { greater_than: 0.00 }
  validates :registration_deadline, presence: true
  validates :min_participant, presence: true, numericality: { greater_than: 0 }
  validates :max_participant, presence: true, numericality: { greater_than: 0 }

end
