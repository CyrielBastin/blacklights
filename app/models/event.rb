# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  start_date            :datetime
#  end_date              :datetime
#  location_id           :bigint
#  price                 :decimal(10, 3)
#  registration_deadline :datetime
#  min_participant       :integer
#  max_participant       :integer
#  contact_id            :bigint
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  name                  :string(255)
#
class Event < ApplicationRecord
  include DuplicateHelper
  include ForbiddenCharacter

  default_scope -> { order(:start_date) }
  scope :to_come, -> { where(['start_date > ?', DateTime.now]) }
  scope :previous, -> { where(['start_date < ?', DateTime.now]) }

  belongs_to :location
  belongs_to :contact, dependent: :destroy
  accepts_nested_attributes_for :contact
  has_many :event_activities, inverse_of: :event, dependent: :destroy
  accepts_nested_attributes_for :event_activities, allow_destroy: true
  has_many :event_equipment, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :event_categories, dependent: :destroy
  has_many :consortium_events, dependent: :destroy

  min_char_name = 8
  min_price = 0.00
  min_participant = 0
  ERR_MSG = { start_date_in_the_past: 'ne peut pas être dans le passé',
              end_date_is_before_start_date: 'doit prendre place après la date de début',
              registration_deadline_after_start_date: 'doit prendre place avant la date de début',
              name_is_too_short: "doit contenir au moins #{min_char_name} caractères",
              price_is_lesser_than_one: "doit être plus grand que #{min_price}€",
              min_participant_is_lesser_than_one: "doit être au moins de #{min_participant} personne(s)",
              max_participant_is_lesser_than_one: "doit être au moins de #{min_participant} personne(s)",
              max_participant_is_lesser_than_min_participant: 'ne peut pas être inférieur au nombre minimum de participants' }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  validate :name_is_valid
  validates :start_date, :end_date, :registration_deadline, :location_id, presence: true
  validate :start_date_is_in_the_future, :end_date_is_higher_than_start_date, :registration_deadline_is_before_start_date
  validates :price, presence: true,
                    numericality: { greater_than: min_price, message: ERR_MSG[:price_is_lesser_than_one] }
  validates :min_participant, presence: true,
                              numericality: { greater_than: min_participant, message: ERR_MSG[:min_participant_is_lesser_than_one] }
  validates :max_participant, presence: true,
                              numericality: { greater_than: min_participant, message: ERR_MSG[:max_participant_is_lesser_than_one] }
  validate :max_participant_is_higher_than_min_participant, :max_participants_lesser_than_location_capacity


  ####################################################################################################
  # Custom Validators for an event. They are put here as we need to compare those datas together
  ####################################################################################################
  def start_date_is_in_the_future
    return if start_date.nil?

    unless start_date > DateTime.now
      errors.add(:start_date, ERR_MSG[:start_date_in_the_past])
    end
  end

  def end_date_is_higher_than_start_date
    return if end_date.nil? || start_date.nil?

    unless end_date > start_date
      errors.add(:end_date, ERR_MSG[:end_date_is_before_start_date])
    end
  end

  def registration_deadline_is_before_start_date
    return if registration_deadline.nil? || start_date.nil?

    unless registration_deadline < start_date
      errors.add(:registration_deadline, ERR_MSG[:registration_deadline_after_start_date])
    end
  end

  def max_participant_is_higher_than_min_participant
    return if max_participant.nil? || min_participant.nil?

    unless max_participant > min_participant
      errors.add(:max_participant, ERR_MSG[:max_participant_is_lesser_than_min_participant])
    end
  end

  def max_participants_lesser_than_location_capacity
    return if max_participant.nil? || location_id.nil?

    l = nil
    begin
      l = Location.find(location_id)
    rescue
    end
    return if l.nil?

    errors.add(:max_participant, "ne peut pas être plus grand que #{l[:capacity]}") if max_participant > l[:capacity]
  end

  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
  end

  ####################################################################################################
  # Life cycle events
  ####################################################################################################

  before_save :add_up_all_duplicates

  private

  def add_up_all_duplicates
    unless event_activities.empty?
      self.event_activities = add_up_duplicates(event_activities,
                                                id: :activity_id,
                                                quantity: :simultaneous_activities)
    end
    unless event_equipment.empty?
      self.event_equipment = add_up_duplicates(event_equipment,
                                               id: :equipment_id,
                                               quantity: :quantity)
    end
  end

  def self.inheritance_column
    nil
  end

end
