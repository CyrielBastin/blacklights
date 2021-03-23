class EventEquipment < ApplicationRecord

  belongs_to :event
  belongs_to :equipment

end
