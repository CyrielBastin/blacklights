# This module contains the forbidden characters for 'Equipment name', 'Location name', 'Activity name'
# This module is needed for the import functionality. For example, in the sheet 'Activity', the column for equipment
# will look like "equipment_name (quantity) + equipment2_name (quantity2) + ..." ==> "Raquettes (2) + Balles de tennis (4) + ..."
# If you change the symbols to separate equipment and quantity, you will have to change the list of forbidden characters
# in the method <forbidden_characters> present inside this module
module ForbiddenCharacter

  # @param [String] str
  # @return [Boolean]
  def contains_forbidden_char?(str)
    return true if str.match(/["#{packed_forbidden_characters}"]/)

    false
  end

  def forbidden_char_msg
    "ne peut pas contenir les caractères suivants =>  #{forbidden_char_as_str}"
  end

  # @param [String] str
  # @return [Boolean]
  def contains_forbidden_comma?(str)
    return true if str.match(/,/)

    false
  end

  def forbidden_comma_msg
    'ne peut pas contenir de virgule \',\''
  end

  private

  def forbidden_characters
    %w[+ ( )]
  end

  def packed_forbidden_characters
    str = ''
    forbidden_characters.each do |char|
      str += char
    end

    str
  end

  # @return string
  def forbidden_char_as_str
    str = ''
    forbidden_characters.each do |c|
      str += "' #{c} ', "
    end

    str[...-2]
  end

end
