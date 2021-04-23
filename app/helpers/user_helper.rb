module UserHelper

  # Each user must complete their profile before they can register for an event.
  # This method checks if +user+ has completed their profile and are eligible to partake in an event.
  #
  # @param [ActiveRecord::User] user
  # @return [Boolean]
  def registration_eligible?(user)
    user.profile[:birthdate].present? && user.contact.coordinate.present?
  end

end
