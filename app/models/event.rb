class Event < ApplicationRecord

  belongs_to :location
  belongs_to :contact
  accepts_nested_attributes_for :contact
  has_many :event_activities
  has_many :registrations
  has_many :event_activity_equipment, inverse_of: :event
  accepts_nested_attributes_for :event_activity_equipment, allow_destroy: true

  min_price = 0.00
  min_participant = 0
  err_msg = { price_is_blank: 'Le prix ne peut pas être vide',
              price_is_lesser_than_one: "Le prix doît être plus grand que #{min_price}€",
              min_participant_is_blank: 'Le nombre minimum de participants ne peut pas être vide',
              min_participant_is_lesser_than_one: "Le nombre minimum de participants doît être au moins de #{min_participant} personne(s)",
              max_participant_is_blank: 'Le nombre maximum de participants ne peut pas être vide',
              max_participant_is_lesser_than_one: "Le nombre maximum de participants doît être au moins de #{min_participant} personne(s)" }

  validates :start_date, :end_date, :registration_deadline, presence: true
  validates :price, presence: { message: err_msg[:price_is_blank] },
                    numericality: { greater_than: min_price, message: err_msg[:price_is_lesser_than_one] }
  validates :min_participant, presence: { message: err_msg[:min_participant_is_blank] },
                              numericality: { greater_than: min_participant, message: err_msg[:min_participant_is_lesser_than_one] }
  validates :max_participant, presence: { message: err_msg[:max_participant_is_blank] },
                              numericality: { greater_than: min_participant, message: err_msg[:max_participant_is_lesser_than_one] }

end
