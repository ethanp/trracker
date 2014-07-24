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
  def heatmap_format
    # TODO
  end
end
