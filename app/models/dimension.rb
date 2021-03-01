class Dimension < ApplicationRecord

  has_one :equipment
  has_one :location

  validates :width, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :length, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :height, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
end
