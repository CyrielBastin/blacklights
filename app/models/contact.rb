class Contact < ApplicationRecord

  belongs_to :coordinate
  has_one :supplier
  has_one :location
  has_one :event

  accepts_nested_attributes_for :coordinate

  validates :lastname, :firstname, presence: true, length: { minimum: 3 }
  validates :phone_number, presence: true, length: { minimum: 10 }
  validates :email, presence: true, email: true
end
