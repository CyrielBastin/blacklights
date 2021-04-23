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

  scope :for_event, -> { where('category_for = event') }
  scope :for_equipment, -> { where('category_for = equipment') }

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'
  enumerize :category_for, in: %i[equipment activity event]
  has_many :equipment
  has_many :events

  min_char_name = 5
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validates :category_for, presence: true

end
