class AssociationActivity < ApplicationRecord

  belongs_to :association, class_name: 'Association'
  belongs_to :activity

end
