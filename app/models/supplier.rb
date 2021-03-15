class Supplier < ApplicationRecord

  default_scope -> { order(:name) }

  belongs_to :contact, dependent: :destroy
  has_many :equipments

  accepts_nested_attributes_for :contact

  min_char_name = 4
  err_msg = { name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              name_already_exists: 'Ce nom existe déjà dans la base de données' }
  validates :name, presence: { message: err_msg[:name_is_blank] },
                   length: { minimum: min_char_name, message: err_msg[:name_is_too_short] },
                   uniqueness: { message: err_msg[:name_already_exists] }

end
