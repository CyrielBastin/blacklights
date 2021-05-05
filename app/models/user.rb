# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string(255)
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#
class User < ApplicationRecord
  rolify
  include ForbiddenCharacter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :invitable

  scope :active, -> { where('deleted_at is null') }

  validates :email, presence: true
  validate :email_is_valid
  validates_uniqueness_of :email

  has_many :locations
  has_many :events
  has_many :supplier_users, dependent: :destroy
  has_many :entity_users, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_one :profile, inverse_of: :user, dependent: :destroy
  has_one :contact, through: :profile
  attr_accessor :skip_password_validation

  accepts_nested_attributes_for :profile

  def invited?
    invitation_sent_at.present?
  end

  def confirmed?
    last_sign_in_at.present?
  end

  private

  def password_required?
    return false if skip_password_validation
    super
  end

  def email_is_valid
    return if email.nil?

    errors.add(:email, forbidden_ampersand_msg) if contains_forbidden_ampersand?(email)
  end

end
