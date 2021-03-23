class EventEquipment < ApplicationRecord
  self.table_name = 'event_equipment'

  belongs_to :event
  belongs_to :equipment

  min_quantity = 0.00
  ERR_MSG = { quantity_is_blank: 'La quantité ne peut pas être vide',
              quantity_is_lesser_than_one: "La quantité doit être plus grand que #{min_quantity}" }.freeze

  validates :quantity, presence: { message: ERR_MSG[:quantity_is_blank] },
                       numericality: { greater_than: min_quantity, message: ERR_MSG[:quantity_is_lesser_than_one] }

end
