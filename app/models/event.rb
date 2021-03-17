class Event < ApplicationRecord

  belongs_to :location
  belongs_to :contact, dependent: :destroy
  accepts_nested_attributes_for :contact
  has_many :event_activities, inverse_of: :event, dependent: :destroy
  accepts_nested_attributes_for :event_activities, allow_destroy: true
  has_many :event_equipment, inverse_of: :event, dependent: :destroy
  accepts_nested_attributes_for :event_equipment, allow_destroy: true
  has_many :registrations, dependent: :destroy

  min_char_name = 8
  min_price = 0.00
  min_participant = 0
  ERR_MSG = { start_date_in_the_past: 'La date de début ne peut pas être dans le passé',
              end_date_is_before_start_date: 'La date de fin ne peut pas être avant la date de début',
              registration_deadline_in_the_future: 'La date de clôture des inscriptions ne peut pas être dans le passé',
              registration_deadline_after_start_date: 'La date de clôture des inscriptions doit être avant la date de début',
              end_date_too_low: 'La date de fin doit être avant la date de début',
              name_is_blank: 'Le nom ne peut pas être vide',
              name_is_too_short: "Le nom doit contenir au moins #{min_char_name} caractères",
              price_is_blank: 'Le prix ne peut pas être vide',
              price_is_lesser_than_one: "Le prix doît être plus grand que #{min_price}€",
              min_participant_is_blank: 'Le nombre minimum de participants ne peut pas être vide',
              min_participant_is_lesser_than_one: "Le nombre minimum de participants doît être au moins de #{min_participant} personne(s)",
              max_participant_is_blank: 'Le nombre maximum de participants ne peut pas être vide',
              max_participant_is_lesser_than_one: "Le nombre maximum de participants doît être au moins de #{min_participant} personne(s)",
              max_participant_is_lesser_than_min_participant: 'Le nombre maximum de participants ne peut pas être inférieur au nombre minimum de participants' }.freeze

  validates :name, presence: { message: ERR_MSG[:name_is_blank] },
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validates :start_date, :end_date, :registration_deadline, presence: true
  validate :start_date_is_in_the_future, :end_date_is_higher_than_start_date, :registration_deadline_is_in_the_future, :registration_deadline_is_before_start_date
  validates :price, presence: { message: ERR_MSG[:price_is_blank] },
                    numericality: { greater_than: min_price, message: ERR_MSG[:price_is_lesser_than_one] }
  validates :min_participant, presence: { message: ERR_MSG[:min_participant_is_blank] },
                              numericality: { greater_than: min_participant, message: ERR_MSG[:min_participant_is_lesser_than_one] }
  validates :max_participant, presence: { message: ERR_MSG[:max_participant_is_blank] },
                              numericality: { greater_than: min_participant, message: ERR_MSG[:max_participant_is_lesser_than_one] }
  validate :max_participant_is_higher_than_min_participant


  def datetime_to_french_format(date_time)
    date_time.strftime('%d/%m/%Y, à %H:%M')
  end

  ####################################################################################################
  # Custom Validators for an event. They are put here as we need to compare those datas together
  ####################################################################################################
  def start_date_is_in_the_future
    unless start_date > DateTime.now
      errors.add(:start_date, ERR_MSG[:start_date_in_the_past])
    end
  end

  def end_date_is_higher_than_start_date
    unless end_date > start_date
      errors.add(:end_date, ERR_MSG[:end_date_is_before_start_date])
    end
  end

  def registration_deadline_is_in_the_future
    unless registration_deadline > DateTime.now
      errors.add(:registration_deadline, ERR_MSG[:registration_deadline_in_the_future])
    end
  end

  def registration_deadline_is_before_start_date
    unless registration_deadline < start_date
      errors.add(:registration_deadline, ERR_MSG[:registration_deadline_after_start_date])
    end
  end

  def max_participant_is_higher_than_min_participant
    unless max_participant > min_participant
      errors.add(:max_participant, ERR_MSG[:max_participant_is_lesser_than_min_participant])
    end
  end

end
