{
  mini_date: "%b %-d %Y",
  mini_date_time: "%b %-d %Y at %-l:%M%P"
}.each do |format_name, format_string|
  Time::DATE_FORMATS[format_name] = format_string
end
