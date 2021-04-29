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

  has_many :equipments
  has_many :supplier_contacts


  min_char_name = 3
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validate :name_is_valid

  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

end
