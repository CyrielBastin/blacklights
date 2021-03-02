class Coordinate < ApplicationRecord

  has_one :contact
  has_one :location

  validates :street, presence: true, length: { minimum: 8 }
  validates :zip_code, presence: true, numericality: true, length: { minimum: 4, maximum: 5 }
  validates :city, :country, presence: true, length: { minimum: 3 }
end
