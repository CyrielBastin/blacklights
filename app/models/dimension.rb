class Dimension < ApplicationRecord

  has_one :equipment
  has_one :location

  validates :width, :length, :height, :weight, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
end
