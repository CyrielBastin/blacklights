# == Schema Information
#
# Table name: dimensions
#
#  id     :bigint           not null, primary key
#  width  :decimal(10, 3)
#  length :decimal(10, 3)
#  height :decimal(10, 3)
#  weight :decimal(10, 3)
#
class Dimension < ApplicationRecord

  has_one :equipment
  has_one :location

  min_dimension = 0.01
  ERR_MSG = { too_short: "doit être au moins de #{min_dimension} cm",
              weight_is_too_short: "doit être au moins de #{min_dimension} g" }.freeze

  validates :width, :length, :height, presence: true,
                                      numericality: { greater_than_or_equal_to: min_dimension, message: ERR_MSG[:too_short] }
  validates :weight, presence: true,
                     numericality: { greater_than_or_equal_to: min_dimension, message: ERR_MSG[:weight_is_too_short] }

end
