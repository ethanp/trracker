class Time
  def seconds_to_next_hour
    (60*60 - (self-self.beginning_of_hour))
  end
  def hour_fraction_to_next_hour
    self.seconds_to_next_hour / (60*60)
  end
end
