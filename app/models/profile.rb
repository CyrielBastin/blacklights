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


  ####################################################################################################
  # Custom Validators
  ####################################################################################################
  def birthdate_in_past
    return if birthdate.nil?

    unless birthdate < Date.today
      errors.add(:birthdate, '')
    end
  end

end
