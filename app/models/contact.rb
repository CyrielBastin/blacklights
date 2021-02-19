class Contact < ApplicationRecord


  has_one :supplier
  has_one :location
  has_one :event
end
