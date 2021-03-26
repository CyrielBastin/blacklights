# This module contains the helpers to handle the import-export to Excel format
module ImportExportHelper

  def assemble_pieces_together (objects, attributes = {})
    obj_name, name = attributes[:obj_name], attributes[:name]
    assembled_objects = []
    objects.each do |object|
      if object[attributes[:obj_to_assemble]].present?
        assembled_str = ''
        object[attributes[:obj_to_assemble]].each do |sub_obj|
          if attributes[:quantity].present?
            assembled_str += "#{sub_obj[obj_name][name]} (#{sub_obj[attributes[:quantity]]}), "
          else
            assembled_str += "#{sub_obj[obj_name][name]}, "
          end
        end
        assembled_objects << assembled_str
      else
        assembled_objects << ''
      end
    end

    assembled_objects
  end

end
