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
  extend Enumerize

  default_scope -> { order(:name) }

  belongs_to :user
  belongs_to :dimension, dependent: :destroy
  has_many :location_activities, dependent: :destroy
  has_many :entity_locations, dependent: :destroy
  has_many :events

  accepts_nested_attributes_for :user, :dimension, :location_activities

  enumerize :type, in: %i[private public], predicates: true, scope: true

  min_char_name = 3
  min_capacity = 0
  min_char_zip_code, max_char_zip_code = 4, 5
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères",
              capacity_below_zero: "ne peut pas être inférieur à #{min_capacity}",
              zip_code_NaN: 'doit être un nombre',
              zip_code_range: "doit contenir au moins #{min_char_zip_code} et au plus #{max_char_zip_code} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validate :name_is_valid
  validates :type, :street, :city, :country, presence: true
  validate :city_is_valid
  validates :zip_code, presence: true,
                       numericality: { only_integer: true, message: ERR_MSG[:zip_code_NaN] },
                       length: { minimum: min_char_zip_code, maximum: max_char_zip_code, message: ERR_MSG[:zip_code_range] }


  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_char_msg) if contains_forbidden_char?(name)
    errors.add(:name, forbidden_comma_msg) if contains_forbidden_comma?(name)
    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

  def city_is_valid
    return if city.nil?

    errors.add(:city, forbidden_comma_msg) if contains_forbidden_comma?(city)
    errors.add(:city, forbidden_ampersand_msg) if contains_forbidden_ampersand?(city)
  end

  def name_plus_city
    "#{name}, #{city}"
  end


  def self.inheritance_column
    nil
  end

end
