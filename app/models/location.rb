class Location < ApplicationRecord

  default_scope -> { order(:name) }

  belongs_to :contact, dependent: :destroy
  belongs_to :dimension, dependent: :destroy
  has_many :location_activities, dependent: :destroy
  has_many :events

  accepts_nested_attributes_for :contact, :dimension, :location_activities

  min_char_name = 3
  min_char_type = 7
  err_msg = { name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              name_already_exists: 'Ce nom existe déjà dans la base de données',
              type_is_blank: 'Le type ne peut pas être vide',
              type_is_too_short: "Le type doit contenir au moins #{min_char_type} caractères" }

  validates :name, presence: { message: err_msg[:name_is_blank] },
                   length: { minimum: min_char_name, message: err_msg[:name_is_too_short] },
                   uniqueness: { message: err_msg[:name_already_exists] }
  validates :type, presence: { message: err_msg[:type_is_blank] },
                   length: { minimum: min_char_type, message: err_msg[:type_is_too_short] }

  def self.inheritance_column
    nil
  end

end
