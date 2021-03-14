class ActivityEquipment < ApplicationRecord

  belongs_to :activity
  belongs_to :equipment

  min_qty = 0.00
  err_msg = { quantity_is_blank: 'La quantité ne peut pas être vide',
              quantity_is_lesser_than_one: "La quantité doit être plus grand que #{min_qty}" }
  validates :quantity, presence: { message: err_msg[:quantity_is_blank] },
                       numericality: { greater_than: min_qty, message: err_msg[:quantity_is_lesser_than_one] }

end
