module ApplicationHelper
  def datepicker_format(field)
    field.nil? ? nil : field.strftime(Time::DATE_FORMATS[:datetimepicker])
  end
  def date_string(date)
    date.nil? ? "" : date.strftime(Date::DATE_FORMATS[:full_text])
  end
end
