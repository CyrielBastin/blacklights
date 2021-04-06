# == Schema Information
#
# Table name: profiles
#
#  gender       :string(255)
#  birthdate    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Profile < ActiveRecord::Base
  include ApplicationHelper
  extend Enumerize

  belongs_to :user
  belongs_to :contact, dependent: :destroy
  accepts_nested_attributes_for :contact

  enumerize :gender, in: [:male, :female], predicates: true, scope: true

  validates :gender, presence: true
  validates :birthdate, presence: true
  validate :birthdate_in_past


  ###################################################################################################
  # Custom validatiors
  ###################################################################################################

  def birthdate_in_past
    return if birthdate.nil?

    # we use 2 hours from now for a correct datetime !!! Careful with the UTC +02:00
    unless birthdate <= Date.today
      errors.add(:birthdate, 'ne peut pas être dans le futur')
    end
  end

end
