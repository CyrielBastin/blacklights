class Supplier < ApplicationRecord

  belongs_to :contact
  has_many :equipments

end
