class Dimension < ApplicationRecord

  has_one :equipment
  has_one :location

  min_width = min_length = min_height = min_weight = 0.01
  err_msg = { width_is_blank: 'La largeur ne peut pas être vide',
              width_is_too_short: "La largeur doit être au moins de #{min_width} cm",
              length_is_blank: 'La longueur ne peut pas être vide',
              length_is_too_short: "La longueur doit être au moins de #{min_length} cm",
              height_is_blank: 'La hauteur ne peut pas être vide',
              height_is_too_short: "La hauteur doit être au moins de #{min_height} cm",
              weight_is_blank: 'Le poids ne peut pas être vide',
              weight_is_too_short: "Le poids doit être au moins de #{min_weight} cm" }

  validates :width, presence: { message: err_msg[:width_is_blank] },
                    numericality: { greater_than_or_equal_to: min_width, message: err_msg[:width_is_too_short] }
  validates :length, presence: { message: err_msg[:length_is_blank] },
                     numericality: { greater_than_or_equal_to: min_length, message: err_msg[:length_is_too_short] }
  validates :height, presence: { message: err_msg[:height_is_blank] },
                     numericality: { greater_than_or_equal_to: min_height, message: err_msg[:height_is_too_short] }
  validates :weight, presence: { message: err_msg[:weight_is_blank] },
                     numericality: { greater_than_or_equal_to: min_weight, message: err_msg[:weight_is_too_short] }

end
