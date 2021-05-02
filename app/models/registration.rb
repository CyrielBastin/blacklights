# == Schema Information
#
# Table name: registrations
#
#  id                            :bigint           not null, primary key
#  event_id                      :bigint
#  user_id                       :bigint
#  price                         :decimal(10, 3)
#  confirmation_datetime         :datetime
#  payment_confirmation_datetime :datetime
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
class Registration < ApplicationRecord
  include UserHelper


  # Require to modify 'config/database.yml'
  # Add a new key under default config
  # variables:
  #   sql_mode: traditional
  #
  # Without that, ActiveRecord will throw an error on the 'group by' statement
  scope :for_events_to_come, -> { Event.joins(:registrations).where(['events.start_date > ?', DateTime.now]).group('events.name') }
  scope :for_every_events, -> { joins(:event).order('events.start_date') }

  belongs_to :event
  belongs_to :user


  validates :price, presence: true
  validates :event_id, :user_id, presence: true
  validate :user_profile_completed


  ###################################################################################################
  # Custom validators
  ###################################################################################################

  def user_profile_completed
    return if user_id.nil?

    u = nil
    begin
      u = User.find(user_id)
    rescue
    end
    return if u.nil?

    unless registration_eligible?(u)
      errors.add(:user_id, 'doit avoir un profil complet pour s\'enregistrer')
    end
  end

end
