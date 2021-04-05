# This module contains the helpers to handle the export to Excel format
module ExportHelper

  # This method is here to assemble pieces together before inserting them in a cell of Excel document
  # If you have several locations available for an activity, it will combine them all in a single string.
  # Example : activity: 'badminton', locations: ['Namur', 'Liège', 'Bruxelles'] will combine all locations to 'Namur + Liège + Bruxelles'
  # Params :
  #   objects => Represents an array of all objects fetch from the database. It is the model you wish to export
  #     - example: Activity.all
  #   attributes => Represents an hash containing which values to combine together. It can take 4 different keys !
  #     :obj_to_assemble => Represents the object to assemble
  #       - example: :activity_equipment
  #     :obj_name => Represents the name of the objects to assemble
  #       - example: :equipment
  #     :name => Represents the attribute of obj_name you want to assemble
  #       - example: :name
  #     :quantity => Represents the attribute of obj_to_assemble to assemble with :name
  #       - example: :quantity
  # Example: assemble_pieces_together(Activity.all, obj_to_assemble: :activity_equipment, obj_name: :equipment, name: :name, quantity: :quantity)
  # will return an array of strings containing the combination of the equipment and their quantity for each activities.
  # ['Raquette de badminton (4) + Projecteur (2) + Volant (4)' + '...' + ...]
  def assemble_pieces_together (objects, attributes = {})
    obj_to_assemble, obj_name, name = attributes[:obj_to_assemble], attributes[:obj_name], attributes[:name]
    assembled_objects = []
    objects.each do |object|
      if object.method(obj_to_assemble).call.empty?
        assembled_objects << ''
      else
        assembled_str = ''
        object.method(obj_to_assemble).call.each do |sub_obj|
          if attributes[:quantity].present?
            assembled_str += "#{sub_obj.method(obj_name).call[name]} (#{sub_obj[attributes[:quantity]]}) + "
          else
            assembled_str += "#{sub_obj.method(obj_name).call[name]} + "
          end
        end
        assembled_objects << assembled_str
      end
    end

    assembled_objects.collect { |str| str[...-3] }
  end

end
