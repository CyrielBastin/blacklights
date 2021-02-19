class Equipment < ApplicationRecord

  belongs_to :category
  belongs_to :supplier
  belongs_to :dimension
  has_many :activity_equipments
  has_many :event_activity_equipments

end
