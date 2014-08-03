class Interval < ActiveRecord::Base
  belongs_to :task

  # validations
  validates_presence_of :start, :end, :task_id

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

    def weekday_num(day)
      day == 0 ? 7 : day
    end
    def hour_num(hour)
      hour == 0 ? 24 : hour
    end

    total_seconds = self.seconds_spent.to_f
    curr_time = self.start_time
    rows = []

    while total_seconds - curr_time.seconds_to_next_hour > 0 do
      rows << {
          day:   weekday_num(curr_time.wday),
          date:  curr_time.strftime("%m/%d/%y"),
          hour:  hour_num(curr_time.hour),
          value: curr_time.seconds_to_next_hour / 60 / 60
      }
      total_seconds -= curr_time.seconds_to_next_hour
      curr_time     += curr_time.seconds_to_next_hour.seconds
    end

    if total_seconds > 0
      rows << {
          day:   weekday_num(curr_time.wday),
          date:  curr_time.strftime("%m/%d/%y"),
          hour:  hour_num(curr_time.hour),
          value: total_seconds / 60 / 60
      }
    end
    rows
  end
end
