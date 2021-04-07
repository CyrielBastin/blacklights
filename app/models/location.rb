# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  name          :string(255)
#  type          :string(255)
#  contact_id    :bigint
#  coordinate_id :bigint
#  dimension_id  :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Location < ApplicationRecord
  include ForbiddenCharacter

  default_scope -> { order(:name) }

  belongs_to :contact, dependent: :destroy
  belongs_to :dimension, dependent: :destroy
  has_many :location_activities, dependent: :destroy
  has_many :events

  accepts_nested_attributes_for :contact, :dimension, :location_activities

  min_char_name = 3
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validate :name_is_valid
  validates :type, presence: true


  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_char_msg) if contains_forbidden_char?(name)
  end


  def self.inheritance_column
    nil
  end

end
