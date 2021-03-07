class Contact < ApplicationRecord

  belongs_to :coordinate
  has_one :supplier
  has_one :location
  has_one :event

  accepts_nested_attributes_for :coordinate


  min_char_lastname = min_char_firstname = 3
  min_char_phone_number = 10
  err_msg = { lastname_is_blank: 'Le nom de famille ne peut pas être vide',
              lastname_is_too_short: "Le nom de famille doit contenir au moins #{min_char_lastname} caractères",
              firstname_is_blank: 'Le prénom ne peut pas être vide',
              firstname_is_too_short: "Le prénom doit contenir au moins #{min_char_firstname} caractères",
              phone_number_is_blank: 'Le numéro de téléphone ne peut pas être vide',
              phone_number_is_too_short: "Le numéro de téléphone doit contenir au moins #{min_char_phone_number} caractères",
              email_is_blank: 'L\'adresse email ne peut pas être vide',
              email_is_not_valid: 'L\'adresse email n\'est pas valide' }

  validates :lastname, presence: { message: err_msg[:lastname_is_blank] },
                       length: { minimum: min_char_lastname, message: err_msg[:lastname_is_too_short] }
  validates :firstname, presence: { message: err_msg[:firstname_is_blank] },
                        length: { minimum: min_char_firstname, message: err_msg[:firstname_is_too_short] }
  validates :phone_number, presence: { message: err_msg[:phone_number_is_blank] },
                           length: { minimum: min_char_phone_number, message: err_msg[:phone_number_is_too_short] }
  validates :email, presence: { message: err_msg[:email_is_blank] }, email: { message: err_msg[:email_is_not_valid] }
end
