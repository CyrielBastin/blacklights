# == Schema Information
#
# Table name: categories
#
#  id        :bigint           not null, primary key
#  name      :string(255)
#  parent_id :bigint
#
class Category < ApplicationRecord
  extend Enumerize

  scope :for_event, -> { where('category_for = Evènement') }
  scope :for_equipment, -> { where('category_for = Matériel') }

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, :class_name => 'Category', :foreign_key => 'parent_id'
  enumerize :category_for, in: ['Evènement', 'Matériel']
  has_many :equipment
  has_many :events

  min_char_name = 5
  ERR_MSG = { name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              name_already_exists: 'Ce nom existe déjà dans la base de données',
              category_for_is_blank: 'Ce champ ne peut pas être vide' }.freeze

  validates :name, presence: { message: ERR_MSG[:name_is_blank] },
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] },
                   uniqueness: { message: ERR_MSG[:name_already_exists] }
  validates :category_for, presence: { message: ERR_MSG[:category_for_is_blank] }

end
