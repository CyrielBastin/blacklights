class Equipment < ApplicationRecord

  default_scope -> { order(:name) }

  belongs_to :category
  belongs_to :supplier
  belongs_to :dimension, dependent: :destroy
  has_many :activity_equipments
  has_many :event_activity_equipments

  accepts_nested_attributes_for :dimension

  min_char_name = 5
  min_char_description = 20
  min_unit_price = 0.00
  err_msg = { name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              description_is_blank: 'La description ne peut pas être vide',
              description_is_too_short: "La description doit contenir au moins #{min_char_description} caractères",
              unit_price_is_blank: 'Le prix/unité ne peut pas être vide',
              unit_price_is_too_low: "Le prix/unité doit être supérieur à #{min_unit_price}€" }

  validates :name, presence: { message: err_msg[:name_is_blank] },
                   length: { minimum: min_char_name, message: err_msg[:name_is_too_short] }
  validates :description, presence: { message: err_msg[:description_is_blank] },
                          length: { minimum: min_char_description, message: err_msg[:description_is_too_short] }
  validates :unit_price, presence: { message: err_msg[:unit_price_is_blank] },
                         numericality: { greater_than: min_unit_price, message: err_msg[:unit_price_is_too_low] }

end
