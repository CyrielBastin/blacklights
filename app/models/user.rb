class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :invitable

  validates :email, presence: true

  validates_uniqueness_of :email


  has_many :registrations
  has_one :profile, inverse_of: :user, dependent: :nullify
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
end
