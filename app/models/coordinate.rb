# == Schema Information
#
# Table name: coordinates
#
#  id       :bigint           not null, primary key
#  street   :string(255)
#  zip_code :integer
#  city     :string(255)
#  country  :string(255)
#
class Coordinate < ApplicationRecord
  include ForbiddenCharacter

  has_one :contact


  def city_is_valid
    return if city.nil?

    errors.add(:city, forbidden_ampersand_msg) if contains_forbidden_ampersand?(city)
  end

end
