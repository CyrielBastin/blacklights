# == Schema Information
#
# Table name: location_activities
#
#  id          :bigint           not null, primary key
#  location_id :bigint
#  activity_id :bigint
#
class LocationActivity < ApplicationRecord

  belongs_to :location
  belongs_to :activity

end
