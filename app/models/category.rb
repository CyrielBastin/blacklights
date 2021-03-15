class Category < ApplicationRecord

  default_scope -> { order(:name) }

  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, :class_name => 'Category', :foreign_key => 'parent_id'
  has_many :equipments

  min_char_name = 5
  err_msg = { name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              name_already_exists: 'Ce nom existe déjà dans la base de données' }
  validates :name, presence: { message: err_msg[:name_is_blank] },
                   length: { minimum: min_char_name, message: err_msg[:name_is_too_short] },
                   uniqueness: { message: err_msg[:name_already_exists] }

end
