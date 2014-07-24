class Interval < ActiveRecord::Base
  belongs_to :task

  def start_time
    Time.parse(self.start.to_s)
  end

  def end_time
    Time.parse(self.end.to_s)
  end

  def seconds_spent
    self.end_time - self.start_time
  end

  # { day:int, time:int, value:float }
  def heatmap_hash_array

    total_seconds = self.seconds_spent.to_f
    curr_time = self.start_time
    vals = []

    while total_seconds - curr_time.seconds_to_next_hour > 0 do
      vals << {
          day:    curr_time.wday,
          time:   curr_time.hour,
          value:  curr_time.hour_fraction_to_next_hour
      }
      total_seconds -= curr_time.seconds_to_next_hour
      curr_time += curr_time.hour_fraction_to_next_hour.hours
    end

    if total_seconds > 0
      vals << {
          day:    curr_time.wday,
          time:   curr_time.hour,
          value:  total_seconds / (60*60)
      }
    end
  end
end
