# == Schema Information
#
# Table name: event_activities
#
#  id                      :bigint           not null, primary key
#  event_id                :bigint
#  activity_id             :bigint
#  simultaneous_activities :integer
#
class EventActivity < ApplicationRecord

  belongs_to :event
  belongs_to :activity

  min_simultaneous_activities = 0.00
  ERR_MSG = { sim_ac_is_blank: 'Ce champ ne peut pas être vide',
              sim_ac_is_lesser_than_one: "Ce champ doit être plus grand que #{min_simultaneous_activities}" }.freeze

  validates :simultaneous_activities, presence: { message: ERR_MSG[:sim_ac_is_blank] },
                                      numericality: { greater_than: min_simultaneous_activities,
                                                      message: ERR_MSG[:sim_ac_is_lesser_than_one] }

end
