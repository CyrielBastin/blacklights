class Supplier < ApplicationRecord

  belongs_to :contact
  has_many :equipments

  accepts_nested_attributes_for :contact

  min_char_name = 4
  err_msg = { name_not_blank: 'Le nom ne peut pas être vide',
              name_too_short: "Le nom doit contenir au moins #{min_char_name} caractères" }
  validates :name, presence: { message: err_msg[:name_not_blank] },
                   length: { minimum: 4, message: err_msg[:name_too_short] },
                   uniqueness: true

end
