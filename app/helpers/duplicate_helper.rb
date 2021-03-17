module DuplicateHelper

  # This method is meant to add up duplicated fields coming from forms
  # Parameters -
  #   field_with_duplicates => Represents an Hash were each values are an hash (expl: { "1" => { "2", "3" }, ... })
  #                            The keys are meaningless. As for the values, it contains the quantities to add up and the ids
  #   field_attributes => Can take two keys. :id, :quantity
  #                       :id is the id of the duplicated field.
  #                       :quantity is the value to add up.
  # Return -
  #   Returns an hash where the key is the id of the field we added up and the value is the quantity
  #   Return is under the form { id: quantity, id_2: quantity_2, ... }
  # Exemple : add_up_duplicates(params[:activity][:activity_equipment_attributes],
  #                             { id: equipment_id, quantity: quantity })
  # => { "2": "1", "4": "7", ... }
  def add_up_duplicates(field_with_duplicates, field_attributes = {})
    no_duplicate_entry = {}
    field_with_duplicates.each do |_f_key, f_value|
      next if f_value[:_destroy].present?

      found = false
      no_duplicate_entry.each do |key, value|
        if f_value[field_attributes[:id]] == key
          no_duplicate_entry[key] = value.to_i + f_value[field_attributes[:quantity]].to_i
          found = true
        end
      end
      no_duplicate_entry[f_value[field_attributes[:id]]] = f_value[field_attributes[:quantity]] unless found
    end

    no_duplicate_entry
  end

end
