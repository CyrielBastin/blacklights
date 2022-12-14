# == Schema Information
#
# Table name: activity_equipment
#
#  id           :bigint           not null, primary key
#  activity_id  :bigint
#  equipment_id :bigint
#  quantity     :decimal(10, 3)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ActivityEquipment < ApplicationRecord
  self.table_name = 'activity_equipment'

  belongs_to :activity
  belongs_to :equipment

  min_qty = 0
  ERR_MSG = { quantity_is_lesser_than_one: "doit être plus grand que #{min_qty}" }.freeze

  validates :quantity, presence: true,
                       numericality: { greater_than: min_qty, message: ERR_MSG[:quantity_is_lesser_than_one] }

end
