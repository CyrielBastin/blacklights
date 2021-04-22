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

end
