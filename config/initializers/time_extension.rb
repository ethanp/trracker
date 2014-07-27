class Time
  def seconds_to_next_hour
    (60*60 - (self-self.beginning_of_hour))
  end
end
