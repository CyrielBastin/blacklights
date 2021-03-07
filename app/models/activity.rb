class Activity < ApplicationRecord

  has_many :event_activities
  has_many :location_activities
  has_many :event_activity_equipments

  min_char_name = 4
  max_char_name = 30
  min_char_desc = 15
  err_msg = { name_not_blank: 'Le nom ne peut pas être vide',
              name_range: "Le nom doit contenir au minimum #{min_char_name} caractères et au maximum #{max_char_name} caractères",
              descriptiob_not_blank: 'La description ne peut pas être vide',
              description_too_short: "La description doit contenir au moins #{min_char_desc} caractères" }

  validates :name, presence: { message: err_msg[:name_not_blank] },
                   length: { minimum: 4, maximum: 30, message: err_msg[:name_range] }, uniqueness: true
  validates :description, presence: { message: err_msg[:descriptiob_not_blank] },
                          length: { minimum: 15, message: err_msg[:description_too_short] }

end
