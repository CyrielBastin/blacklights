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

  default_scope -> { order(:name) }

  belongs_to :contact, dependent: :destroy
  belongs_to :dimension, dependent: :destroy
  has_many :location_activities, dependent: :destroy
  has_many :events

  accepts_nested_attributes_for :contact, :dimension, :location_activities

  min_char_name = 3
  min_char_type = 7
  ERR_MSG = { name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              type_is_blank: 'Le type ne peut pas être vide',
              type_is_too_short: "Le type doit contenir au moins #{min_char_type} caractères" }.freeze

  validates :name, presence: { message: ERR_MSG[:name_is_blank] },
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validates :type, presence: { message: ERR_MSG[:type_is_blank] },
                   length: { minimum: min_char_type, message: ERR_MSG[:type_is_too_short] }

  def self.inheritance_column
    nil
  end

end
