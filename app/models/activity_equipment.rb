class ActivityEquipment < ApplicationRecord
  self.table_name = 'activity_equipment'

  belongs_to :activity
  belongs_to :equipment

  min_qty = 0.00
  ERR_MSG = { quantity_is_blank: 'La quantité ne peut pas être vide',
              quantity_is_lesser_than_one: "La quantité doit être plus grand que #{min_qty}" }.freeze

  validates :quantity, presence: { message: ERR_MSG[:quantity_is_blank] },
                       numericality: { greater_than: min_qty, message: ERR_MSG[:quantity_is_lesser_than_one] }

end
