class Profile < ActiveRecord::Base
  include ApplicationHelper
  extend Enumerize

  belongs_to :user

  enumerize :gender, in: [:male, :female], predicates: true, scope: true


  def full_name
    "#{firstname} #{lastname}"
  end

  def initials
    if lastname.present?
      "#{firstname[0]} #{lastname[0]}"
    else
      "#{firstname[0]} #{firstname[1]}"
    end
  end
end
