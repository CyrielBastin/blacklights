module DateTimeHelper

  # Takes a DateTime as parameter and returns its french representation
  # @param [DateTime] date_time
  # @return [String] empty String if +date_time+ is nil
  def date_time_to_french_format(date_time)
    return '' if date_time.nil?

    date_time.strftime('%d/%m/%Y, à %H:%M')
  end

  # Takes a Date as parameter and returns its french representation
  # @param [Date] date
  # @return [String] empty String if +date+ is nil
  def date_to_french_format(date)
    return '' if date.nil?

    date.strftime('%d/%m/%Y')
  end

end
