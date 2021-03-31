# This module converts floating point number to their English or French representation
module ConvertFloat

  def to_french_repr(float_number)
    str = float_number.to_s
    begin
      str['.'] = ','
    rescue IndexError
      # Ignored
    end

    str
  end

  def to_english_repr(float_number)
    str = float_number.to_s
    begin
      str[','] = '.'
    rescue IndexError
      # Ignored
    end

    str
  end

end
