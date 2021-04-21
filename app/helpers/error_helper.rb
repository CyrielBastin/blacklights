module ErrorHelper

  # @param class_name [Symbol]
  # @param str [String]
  # @return [String]
  def epurate_err_msg(class_name, str)
    str["#{class_name.to_s} "] = ''

    str
  end

end
