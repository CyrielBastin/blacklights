# == Schema Information
#
# Table name: activities
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Activity < ApplicationRecord
  include DuplicateHelper

  default_scope -> { order(:name) }

  has_many :event_activities, dependent: :destroy
  has_many :location_activities, dependent: :destroy
  has_many :activity_equipment, dependent: :destroy, inverse_of: :activity
  accepts_nested_attributes_for :activity_equipment, allow_destroy: true

  min_char_name = 4
  max_char_name = 30
  min_char_desc = 15
  ERR_MSG = { name_range: "doit contenir au minimum #{min_char_name} caractères et au maximum #{max_char_name} caractères",
              description_too_short: "doit contenir au moins #{min_char_desc} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, maximum: max_char_name, message: ERR_MSG[:name_range] }
  validates :description, presence: true,
                          length: { minimum: min_char_desc, message: ERR_MSG[:description_too_short] }

  def self.get_activities_by_location_id(id)
    ActiveRecord::Base.connection.exec_query("select activities.name, activities.id from activities
                                              inner join location_activities on activity_id = activities.id
                                              where location_id = #{id}
                                              order by activities.name;")
  end

  ####################################################################################################
  # Life cycle events
  ####################################################################################################

  before_save :add_up_equipment_duplicates

  private

  def add_up_equipment_duplicates
    unless activity_equipment.empty?
      self.activity_equipment = add_up_duplicates(activity_equipment, id: :equipment_id, quantity: :quantity)
    end
  end

end
