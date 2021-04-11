module DuplicateHelper

  # This method takes an array of object and returns a new array in which the duplicated fields have been added up
  # - Params :
  #     array_with_duplicates => Array of objects that contains fields you which add up the duplicates
  #     field_attributes => 2 different keys (:id, :quantity)
  #        :id => Represents the field that is duplicated
  #        :quantity => Represents the numbers to add up together
  # Example : add_up_duplicates(activity_equipment, id: equipment_id, quantity: quantity)
  # Here activity_equipment is an array of objects 'activity_equipment'
  # Each object has a field 'equipment_id' and 'quantity'
  # We iterate over the array and we add up the 'quantity' for each objects that have the same 'equipment_id'
  # Finally, we return a new array without the duplicates
  def add_up_duplicates(array_with_duplicates, field_attributes = {})
    return if array_with_duplicates.empty?

    no_duplicated_entries = []
    array_with_duplicates.each do |object|
      found = false
      no_duplicated_entries.each do |no_dup_obj|
        if no_dup_obj[field_attributes[:id]] == object[field_attributes[:id]]
          no_dup_obj[field_attributes[:quantity]] += object[field_attributes[:quantity]]
          found = true
        end
      end
      no_duplicated_entries << object unless found
    end

    no_duplicated_entries
  end

  # Checks whether a value for 'name' is present in the table <class> in the database
  # Example : alreadys_exists(:Category, :Balles)
  # will check if for the table associated to the Model 'Category', there is a row with 'name' == 'Balles'
  def name_already_exists?(class_name, value)
    exists = class_name.to_s.constantize.method(:find_by).call({ name: value })

    exists.present?
  end

  # Checks whether the id is already present in the database.
  # Example : alreadys_exists(:Category, 4)
  # will check if for the table associated to the Model 'Category', there is row with 'id' == 4
  def already_exists?(class_name, id)
    begin
      class_name.to_s.constantize.method(:find).call(id)
      true
    rescue ActiveRecord::RecordNotFound
      false
    end
  end

end
