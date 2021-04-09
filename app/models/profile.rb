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

  delegate :full_name, to: :contact
  delegate :initials, to: :contact

  accepts_nested_attributes_for :contact

  enumerize :gender, in: [:male, :female], predicates: true, scope: true

  validates :gender, presence: true
  validate :birthdate_in_past


  ###################################################################################################
  # Custom validatiors
  ###################################################################################################

  def birthdate_in_past
    return if birthdate.nil?

    unless birthdate <= Date.today
      errors.add(:birthdate, 'ne peut pas être dans le futur')
    end
  end

end
