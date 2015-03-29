class Interval < ActiveRecord::Base
  belongs_to :task
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

  # turns a single Interval object into an array of hashes of the form
  #
  #     { day:int, time:int, value:float }
  #
  # one hash per hour
  # for use in the heatmap
  #
  # sunday is day 7
  # 12am is hour 24 # TODO change this here AND in the heatmap to 0 bc that makes more sense
  #
  # e.g.
  #
  #  2.1.2 :012 > i = Interval.last
  #  => #<Interval ..., start: "2015-03-29 17:42:00", end: "2015-03-29 20:42:00", ...>
  #  2.1.2 :013 > i.heatmap_hash_array
  #  => [
  #       {:day=>7, :date=>"03/29/2015", :hour=>12, :value=>0.3},
  #       {:day=>7, :date=>"03/29/2015", :hour=>13, :value=>1.0},
  #       {:day=>7, :date=>"03/29/2015", :hour=>14, :value=>1.0},
  #       {:day=>7, :date=>"03/29/2015", :hour=>15, :value=>0.7}
  #    ]
  #
  def heatmap_hash_array

    def weekday_num(day)
      day == 0 ? 7 : day
    end
    def hour_num(hour)
      hour == 0 ? 24 : hour
    end
    def mdy_date(time)
      time.strftime(d_fmt :mdy)
    end

    total_seconds = self.seconds_spent.to_f
    curr_time = self.start_time
    rows = []

    # get all the hour-hashes that go right up to the next hour
    while total_seconds - curr_time.seconds_to_next_hour > 0 do
      rows << {
          day:   weekday_num(curr_time.wday),
          date:  mdy_date(curr_time),
          hour:  hour_num(curr_time.hour),
          value: curr_time.seconds_to_next_hour / 60 / 60
      }
      total_seconds -= curr_time.seconds_to_next_hour
      curr_time     += curr_time.seconds_to_next_hour.seconds
    end

    # get that last hour's hash
    if total_seconds > 0
      rows << {
          day:   weekday_num(curr_time.wday),
          date:  mdy_date(curr_time),
          hour:  hour_num(curr_time.hour),
          value: total_seconds / 60 / 60
      }
    end
    rows
  end
end
