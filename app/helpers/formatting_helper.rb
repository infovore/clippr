module FormattingHelper
  def format_date(datetime)
    datetime.strftime("%d %B %Y")
  end
  
  def format_time(datetime)
    datetime.strftime("%I:%M%p").downcase
  end
  
  def format_datetime(datetime)
    "#{format_date(datetime)}, #{format_time(datetime)}"
  end
  
end