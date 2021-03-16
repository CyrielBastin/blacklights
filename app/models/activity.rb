class Activity < ApplicationRecord

  default_scope -> { order(:name) }

  has_many :event_activities
  has_many :location_activities, dependent: :destroy
  has_many :activity_equipment, dependent: :destroy, inverse_of: :activity
  accepts_nested_attributes_for :activity_equipment, allow_destroy: true
  has_many :event_equipment

  min_char_name = 4
  max_char_name = 30
  min_char_desc = 15
  ERR_MSG = { name_not_blank: 'Le nom ne peut pas être vide',
              name_range: "Le nom doit contenir au minimum #{min_char_name} caractères et au maximum #{max_char_name} caractères",
              name_already_exists: 'Ce nom existe déjà dans la base de données',
              descriptiob_not_blank: 'La description ne peut pas être vide',
              description_too_short: "La description doit contenir au moins #{min_char_desc} caractères" }.freeze

  validates :name, presence: { message: ERR_MSG[:name_not_blank] },
                   length: { minimum: min_char_name, maximum: max_char_name, message: ERR_MSG[:name_range] },
                   uniqueness: { message: ERR_MSG[:name_already_exists] }
  validates :description, presence: { message: ERR_MSG[:descriptiob_not_blank] },
                          length: { minimum: min_char_desc, message: ERR_MSG[:description_too_short] }

end
