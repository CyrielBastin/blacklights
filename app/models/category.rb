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

  scope :for_equipment, -> { where(['type = ?', :equipment]) }
  scope :for_activity, -> { where(['type = ?', :activity]) }
  scope :for_event, -> { where(['type = ?', :event]) }
  scope :to_export, -> { where('parent_id is null').order(:type) }

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'
  has_many :equipment
  has_many :entities

  enumerize :type, in: %i[equipment activity event]

  validate :name_is_valid
  validates :name, :type, presence: true


  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

  def self.inheritance_column
    nil
  end

end
