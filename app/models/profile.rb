# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  firstname    :string(255)
#  lastname     :string(255)
#  gender       :string(255)
#  birthdate    :date
#  street       :string(255)
#  zipcode      :integer
#  city         :string(255)
#  country      :string(255)
#  phone_number :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
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
