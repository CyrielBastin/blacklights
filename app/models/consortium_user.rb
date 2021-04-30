class ConsortiumUser < ApplicationRecord

  belongs_to :consortium
  belongs_to :user

end
