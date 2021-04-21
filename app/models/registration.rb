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

  belongs_to :event
  belongs_to :user


  validates :price, presence: true, numericality: { greater_than: 0.00 }
  validates :event_id, :user_id, presence: true
  validate :one_registration_per_user, :user_profile_completed


  def Registration.for_events_to_come
    # Require to modify 'config/database.yml'
    # Add a new key under default config
    # variables:
    #   sql_mode: traditional
    #
    # Without that, ActiveRecord will throw an error on the 'group by' statement
    Event.joins(:registrations).where(['events.start_date > ?', DateTime.now]).group('events.name')
  end

  def Registration.for_every_events
    Registration.joins(:event).order('events.start_date')
  end


  ###################################################################################################
  # Custom validators
  ###################################################################################################

  def one_registration_per_user
    return if user_id.nil? || event_id.nil?

    r = Registration.find_by(event_id: event_id, user_id: user_id)
    errors.add(:user_id, 'ne peut pas s\'inscrire deux fois au même évènement') if r.present?
  end

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
