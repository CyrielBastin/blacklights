# == Schema Information
#
# Table name: suppliers
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  contact_id :bigint
#
class Supplier < ApplicationRecord
  include ForbiddenCharacter

  default_scope -> { order(:name) }

  has_many :equipments, dependent: :destroy
  has_many :supplier_users, dependent: :destroy


  min_char_name = 3
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validate :name_is_valid
  validates :email, presence: true, email: true
  validates :phone_number, :country, presence: true
  validate :phone_number_is_valid, :country_is_valid


  def loc_details
    "#{city}, #{zip_code} - #{country}"
  end

  ####################################################################################################
  # Custom Validators
  ####################################################################################################

  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

  def phone_number_is_valid
    return if phone_number.nil?

    errors.add(:phone_number, forbidden_ampersand_msg) if contains_forbidden_ampersand?(phone_number)
  end

  def country_is_valid
    return if country.nil?

    errors.add(:country, forbidden_ampersand_msg) if contains_forbidden_ampersand?(country)
  end

end
