# this is from
# nicoschuele.com/posts/cheatsheet-to-set-app-wide-date-and-time-formats-in-rails

## "simply uncomment the line containing the formats you want"

# Date
# ----------------------------
#Date::DATEFORMATS[:default] = "%Y-%m-%d"  # 2013-11-03
#Date::DATEFORMATS[:default] = "&proc"     # November 3rd, 2013
#Date::DATEFORMATS[:default] = "%B %e, %Y" # November 3, 2013
#Date::DATEFORMATS[:default] = "%e %b %Y"  # 3 Nov 2013
#Date::DATEFORMATS[:default] = "%Y%m%d"    # 20131103
#Date::DATEFORMATS[:default] = "%e %b"     # 3 Nov
#Date::DATE_FORMATS[:default] = ""          # custom


# DateTime
# ----------------------------
#DateTime::DATEFORMATS[:default] = "%Y-%m-%d"  # 2013-11-03 14:22:18
#DateTime::DATEFORMATS[:default] = "&proc"     # November 3rd, 2013 14:22
#DateTime::DATEFORMATS[:default] = "%B %e, %Y" # November 3, 2013 14:22
#DateTime::DATEFORMATS[:default] = "%e %b %Y"  # Sun, 3 Nov 2013 14:22:18 -0700
#DateTime::DATEFORMATS[:default] = "%Y%m%d"    # 20131103142218
#DateTime::DATEFORMATS[:default] = "%e %b"     # 3 Nov 14:22
#DateTime::DATE_FORMATS[:default] = ""          # custom



# Time
# ----------------------------
#Time::DATEFORMATS[:default] = "%Y-%m-%d %H:%M:%S"         # 2013-11-03 14:22:18
#Time::DATEFORMATS[:default] = "&proc"                     # November 3rd, 2013 14:22
# Time::DATEFORMATS[:default] = "%B %d, %Y %H:%M"           # November 3, 2013 14:22
#Time::DATEFORMATS[:default] = "%a, %d %b %Y %H:%M:%S %z"  # Sun, 3 Nov 2013 14:22:18 -0700
#Time::DATEFORMATS[:default] = "%d %b %H:%M"               # 3 Nov 14:22
#Time::DATEFORMATS[:default] = "%Y%m%d%H%M%S"              # 20131103142218
#Time::DATEFORMATS[:default] = "%H:%M"                     # 14:22
#Time::DATEFORMATS[:default] = ""                          # custom

Date::DATE_FORMATS[:full_text] = "%a, %B %d, %Y"  # Sun, November 3, 2013
Time::DATE_FORMATS[:datetimepicker] = "%m/%d/%Y %l:%M %p"
Date::DATE_FORMATS[:mdy] = "%m/%d/%y"
