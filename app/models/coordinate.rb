# == Schema Information
#
# Table name: coordinates
#
#  id       :bigint           not null, primary key
#  street   :string(255)
#  zip_code :integer
#  city     :string(255)
#  country  :string(255)
#
class Coordinate < ApplicationRecord

  has_one :contact
  has_one :location

  min_char_street = 8
  min_char_zip_code, max_char_zip_code = 4, 5
  min_char_city = min_char_country = 3
  ERR_MSG = { street_is_too_short: "doit contenir au moins #{min_char_street} caractères",
              zip_code_is_not_a_number: 'doit être un nombre',
              zip_code_range: "doit contenir au moins #{min_char_zip_code} et au plus #{max_char_zip_code} caractères",
              city_is_too_short: "doit contenir au moins #{min_char_city} caractères",
              country_is_too_short: "doit contenir au moins #{min_char_country} caractères" }.freeze

  validates :street, presence: true,
                     length: { minimum: min_char_street, message: ERR_MSG[:street_is_too_short] }
  validates :zip_code, presence: true,
                       numericality: { only_integer: true, message: ERR_MSG[:zip_code_is_not_a_number] },
                       length: { minimum: min_char_zip_code, maximum: max_char_zip_code, message: ERR_MSG[:zip_code_range] }
  validates :city, presence: true,
                   length: { minimum: min_char_city, message: ERR_MSG[:city_is_too_short] }
  validates :country, presence: true,
                      length: { minimum: min_char_country, message: ERR_MSG[:country_is_too_short] }
end
