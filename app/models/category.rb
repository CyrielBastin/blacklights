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
  include ForbiddenCharacter

  scope :for_equipment, -> { where(['category_for = ?', :equipment]) }
  scope :for_activity, -> { where(['category_for = ?', :activity]) }
  scope :for_event, -> { where(['category_for = ?', :event]) }
  scope :to_export, -> { where('parent_id is null').order(:category_for) }

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'
  enumerize :category_for, in: %i[equipment activity event]
  has_many :equipment
  has_many :events

  min_char_name = 5
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validate :name_is_valid
  validates :category_for, presence: true


  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

end
