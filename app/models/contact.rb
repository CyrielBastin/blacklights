class Contact < ApplicationRecord

  has_one :supplier
  has_one :location
  has_one :event

  validates :lastname, presence: true, length: { minimum: 3 }
  validates :firstname, presence: true, length: { minimum: 3 }
  validates :phone_number, presence: true, length: { minimum: 10 }
  validates :email, presence: true, email: true
end
