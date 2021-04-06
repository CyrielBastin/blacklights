# == Schema Information
#
# Table name: event_equipment
#
#  id           :bigint           not null, primary key
#  event_id     :bigint
#  equipment_id :bigint
#  quantity     :decimal(10, 3)
#
class EventEquipment < ApplicationRecord
  self.table_name = 'event_equipment'

  belongs_to :event
  belongs_to :equipment

  min_quantity = 0
  ERR_MSG = { quantity_is_lesser_than_one: "doit être plus grand que #{min_quantity}" }.freeze

  validates :quantity, presence: true,
                       numericality: { greater_than: min_quantity, message: ERR_MSG[:quantity_is_lesser_than_one] }

end
