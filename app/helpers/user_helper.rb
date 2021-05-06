module UserHelper

  # Each user must complete their profile before they can register for an event.
  # This method checks if +user+ has completed their profile and are eligible to partake in an event.
  #
  # @param [ApplicationRecord::User] user
  # @return [Boolean]
  def registration_eligible?(user)
    user.profile[:birthdate].present? && user.contact.coordinate.present?
  end

  # == Pack all roles for a user into a +String+
  # @example
  #  user = User.find 1
  #  pack_roles_to_fr user
  #  -> "Organisateur - Admin"
  #
  #  if user.roles.empty?, returns "Utilisateur"
  #
  # @param [ApplicationRecord::User] user
  # @return [String]
  def pack_roles_to_fr(user)
    return 'Utilisateur' if user.roles.empty?

    str = ''
    str += ' - Organisateur' if user.has_role? :organizer
    str += ' - Fournisseur' if user.has_role? :supplier
    str += ' - Admin' if user.has_role? :admin

    str[3..]
  end

end
