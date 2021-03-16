class Coordinate < ApplicationRecord

  has_one :contact
  has_one :location

  min_char_street = 8
  min_char_zip_code, max_char_zip_code = 4, 5
  min_char_city = min_char_country = 3
  ERR_MSG = { street_is_blank: 'La \'rue et numéro\' ne peut pas être vide',
              street_is_too_short: "La 'rue et numéro' doit contenir au moins #{min_char_street} caractères",
              zip_code_is_blank: 'Le code postal ne peut pas être vide',
              zip_code_is_not_a_number: 'Le code postal doit être un nombre',
              zip_code_range: "Le code postal doit contenir au moins #{min_char_zip_code} et au plus #{max_char_zip_code} caractères",
              city_is_blank: 'La ville ne peut pas être vide',
              city_is_too_short: "La ville doit contenir au moins #{min_char_city} caractères",
              country_is_blank: 'Le pays ne peut pas être vide',
              country_is_too_short: "Le pays doit contenir au moins #{min_char_country} caractères" }.freeze

  validates :street, presence: { message: ERR_MSG[:street_is_blank] },
                     length: { minimum: min_char_street, message: ERR_MSG[:street_is_too_short] }
  validates :zip_code, presence: { message: ERR_MSG[:zip_code_is_blank] },
                       numericality: { only_integer: true, message: ERR_MSG[:zip_code_is_not_a_number] },
                       length: { minimum: min_char_zip_code, maximum: max_char_zip_code, message: ERR_MSG[:zip_code_range] }
  validates :city, presence: { message: ERR_MSG[:city_is_blank] },
                   length: { minimum: min_char_city, message: ERR_MSG[:city_is_too_short] }
  validates :country, presence: { message: ERR_MSG[:country_is_blank] },
                      length: { minimum: min_char_country, message: ERR_MSG[:country_is_too_short] }
end
