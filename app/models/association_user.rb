class AssociationUser < ApplicationRecord

  belongs_to :association
  belongs_to :user

end
