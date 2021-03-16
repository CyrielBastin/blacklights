class Dimension < ApplicationRecord

  has_one :equipment
  has_one :location

  min_width = min_length = min_height = min_weight = 0.01
  ERR_MSG = { width_is_blank: 'La largeur ne peut pas être vide',
              width_is_too_short: "La largeur doit être au moins de #{min_width} cm",
              length_is_blank: 'La longueur ne peut pas être vide',
              length_is_too_short: "La longueur doit être au moins de #{min_length} cm",
              height_is_blank: 'La hauteur ne peut pas être vide',
              height_is_too_short: "La hauteur doit être au moins de #{min_height} cm",
              weight_is_blank: 'Le poids ne peut pas être vide',
              weight_is_too_short: "Le poids doit être au moins de #{min_weight} cm" }.freeze

  validates :width, presence: { message: ERR_MSG[:width_is_blank] },
                    numericality: { greater_than_or_equal_to: min_width, message: ERR_MSG[:width_is_too_short] }
  validates :length, presence: { message: ERR_MSG[:length_is_blank] },
                     numericality: { greater_than_or_equal_to: min_length, message: ERR_MSG[:length_is_too_short] }
  validates :height, presence: { message: ERR_MSG[:height_is_blank] },
                     numericality: { greater_than_or_equal_to: min_height, message: ERR_MSG[:height_is_too_short] }
  validates :weight, presence: { message: ERR_MSG[:weight_is_blank] },
                     numericality: { greater_than_or_equal_to: min_weight, message: ERR_MSG[:weight_is_too_short] }

end
