class Category < ApplicationRecord

  belongs_to :parent_id, class_name: "Category"
  has_many :equipments

end
