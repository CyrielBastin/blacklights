class Location < ApplicationRecord

  belongs_to :contact
  belongs_to :dimension
  has_many :location_activities
  has_many :events

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :type, presence: true, length: { minimum: 7 }

  def self.inheritance_column
    nil
  end

end
