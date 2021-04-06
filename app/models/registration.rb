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

  belongs_to :event
  belongs_to :user


  validates :price, presence: true, numericality: { greater_than: 0.00 }
  validate :confirmation_datetime_in_past, :payment_confirmation_datetime_in_past
  validates :event_id, :user_id, presence: true


  def Registration.for_events_to_come
    # Require to modify 'config/database.yml'
    # Add a new key under default config
    # variables:
    #   sql_mode: traditional
    #
    # Without that, ActiveRecord will throw an error on the 'group by' statement
    Event.joins(:registrations).where(['events.start_date > ?', DateTime.now]).group('events.name')
  end

  ###################################################################################################
  # Custom validatiors
  ###################################################################################################

  def confirmation_datetime_in_past
    return if confirmation_datetime.nil?

    # we use 2 hours from now for a correct datetime !!! Careful with the UTC +02:00
    unless confirmation_datetime <= 2.hours.from_now
      errors.add(:confirmation_datetime, 'ne peut pas être dans le futur')
    end
  end

  def payment_confirmation_datetime_in_past
    return if payment_confirmation_datetime.nil?

    # we use 2 hours from now for a correct datetime !!! Careful with the UTC +02:00
    unless payment_confirmation_datetime <= 2.hours.from_now
      errors.add(:payment_confirmation_datetime, 'ne peut pas être dans le futur')
    end
  end

end
