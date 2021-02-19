class EventActivityEquipment < ApplicationRecord

  belongs_to :event
  belongs_to :activity
  belongs_to :equipment

end
