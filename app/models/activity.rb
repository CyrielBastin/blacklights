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
  include ForbiddenCharacter

  default_scope -> { order(:name) }
  scope :visible, -> { where(['visible = ?', true]) }

  has_many :event_activities, dependent: :destroy
  has_many :location_activities, dependent: :destroy
  has_many :activity_equipment, dependent: :destroy
  has_many :entity_activities, dependent: :destroy
  belongs_to :category

  min_char_name = 4
  min_char_desc = 10
  ERR_MSG = { name_range: "doit contenir au minimum #{min_char_name} caractères",
              description_too_short: "doit contenir au moins #{min_char_desc} caractères" }.freeze

  validates :name, presence: true,
                   length: { minimum: min_char_name, message: ERR_MSG[:name_range] }
  validate :name_is_valid
  validates :description, presence: true,
                          length: { minimum: min_char_desc, message: ERR_MSG[:description_too_short] }
  validates :category_id, presence: true


  def self.get_activities_by_location_id(id)
    ActiveRecord::Base.connection.exec_query("select activities.name, activities.id from activities
                                              inner join location_activities on activity_id = activities.id
                                              where location_id = #{id}
                                              order by activities.name;")
  end

  def name_is_valid
    return if name.nil?

    errors.add(:name, forbidden_char_msg) if contains_forbidden_char?(name)
    errors.add(:name, forbidden_ampersand_msg) if contains_forbidden_ampersand?(name)
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
