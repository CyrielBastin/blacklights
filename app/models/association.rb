class Association < ApplicationRecord

  belongs_to :category
  has_many :association_users, dependent: :destroy
  has_many :association_locations, dependent: :destroy
  has_many :association_activities, dependent: :destroy
  has_many :association_events, dependent: :destroy

end
