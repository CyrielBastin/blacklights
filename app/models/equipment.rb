# == Schema Information
#
# Table name: equipment
#
#  id           :bigint           not null, primary key
#  name         :string(255)
#  description  :text(65535)
#  category_id  :bigint
#  supplier_id  :bigint
#  dimension_id :bigint
#  unit_price   :decimal(10, 3)
#
class Equipment < ApplicationRecord
  include ForbiddenCharacter

  default_scope -> { order(:name) }

  belongs_to :category
  belongs_to :supplier
  belongs_to :dimension, dependent: :destroy
  has_many :activity_equipment, dependent: :destroy
  has_many :event_equipment, dependent: :destroy

  accepts_nested_attributes_for :dimension

  min_char_name = 5
  min_price = 0.00
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères",
              price_is_too_low: "doit être plus grand que #{min_price}€" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validates :category_id, :supplier_id, presence: true
  validate :name_is_valid
  validates :unit_price, presence: true, numericality: { greater_than: min_price, message: ERR_MSG[:price_is_too_low] }


  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_char_msg) if contains_forbidden_char?(name)
    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

end
