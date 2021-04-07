module DateTimeHelper

  def date_time_to_french_format(date_time)
    date_time.strftime('%d/%m/%Y, à %H:%M')
  end

  def date_to_french_format(date_time)
    date_time.strftime('%d/%m/%Y')
  end

end
