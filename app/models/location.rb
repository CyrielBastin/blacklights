class Location < ApplicationRecord


  belongs_to :contact
  belongs_to :dimension
  has_many :location_activities
  has_many :events

  def self.inheritance_column
    nil
  end

end
