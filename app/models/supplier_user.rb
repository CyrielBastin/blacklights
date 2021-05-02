class SupplierUser < ApplicationRecord

  belongs_to :supplier
  belongs_to :user

end
