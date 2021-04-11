# == Schema Information
#
# Table name: contacts
#
#  id            :bigint           not null, primary key
#  lastname      :string(255)
#  firstname     :string(255)
#  phone_number  :string(255)
#  email         :string(255)
#  coordinate_id :bigint
#
class Contact < ApplicationRecord

  belongs_to :coordinate, dependent: :destroy, optional: true
  has_one :supplier
  has_one :location
  has_one :event
  has_one :profile

  accepts_nested_attributes_for :coordinate


  min_char_name = 3
  # min_char_phone_number = 8
  ERR_MSG = { name_is_too_short: "doit contenir au moins #{min_char_name} caractères",
              # phone_number_is_too_short: "doit contenir au moins #{min_char_phone_number} caractères",
              email_is_not_valid: 'n\'est pas valide' }.freeze

  validates :lastname, :firstname, presence: true,
                                   length: { minimum: min_char_name, message: ERR_MSG[:name_is_too_short] }
  # validates :phone_number, presence: true,
  #                          length: { minimum: min_char_phone_number, message: ERR_MSG[:phone_number_is_too_short] }
  validates :email, presence: true, email: { message: ERR_MSG[:email_is_not_valid] }


  def full_name
    "#{firstname} #{lastname.upcase}"
  end

  def initials
    if lastname.present?
      "#{firstname[0]} #{lastname[0]}"
    else
      "#{firstname[0]} #{firstname[1]}"
    end
  end

end
