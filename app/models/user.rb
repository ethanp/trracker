class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :categories, dependent: :destroy

  # this was so crucial, because now I get #<ActiveRecord::Association> instead of #<Array>
  # which means I can apply the scope "tasks.complete" which would have required filtering
  # an array which would have been much slower.
  has_many :tasks, through: :categories
  has_many :subtasks, through: :tasks
  has_many :intervals, through: :tasks

  def full_name
    "#{first_name} #{last_name}"
  end

  # for each category, have the total amount of time for each day
  def time_per_category_per_day
    times_per_category = self.categories.flat_map { |x| x.time_per_day }
    fill_missing_dates times_per_category
  end

  # for every date where a name doesn't have a value,
  # create a data-point with value 0
  #
  def fill_missing_dates(arr)
    # arr is an array of these: { :date, :name (category.name), :value }
    dates = arr.map { |x| x[:date] }
    first_date = DateTime.strptime(dates.first, d_fmt(:mdy))
    last_date = DateTime.strptime(dates.last, d_fmt(:mdy))
    all_dates = (0..(last_date-first_date).to_i).map { |i| (first_date+i).strftime(d_fmt :mdy) }
    by_name = arr.group_by { |x| x[:name] }
    not_sure = all_dates.flat_map do |date|
      by_name.map do |name, objects|
        value_zero_hash = { date: date, name: name, value: 0 }
        objects.select{ |x| x[:date] == date }.give_default(value_zero_hash)
      end
    end
    not_sure.flatten.sort_by { |x| [x[:date], x[:name]] } # sort by date /then/ name
  end

  # TODO I don't enjoy the piece of code that exists here.
  #
  #  I believe the GOAL is to find the weekly productivity per day,
  #     which should be pretty straightforward.
  #
  #  How about something like the equivalent
  #
  #     intervals_by_date = my_intervals.group_by(_.date).sorted
  #     this_date = intervals_by_date.first.date
  #     last_date = intervals_by_date.last.date
  #     past_week = [0] * 7  # that's Python
  #     i = 0
  #     averages = []
  #     while this_date <= last_date do
  #       if intervals_by_date.has_key? this_date
  #         past_week[i%7] = intervals_by_date[this_date].inject(0.0){|s,a|s+a.productivity}
  #       else
  #         past_week[i%7] = 0.0
  #       end
  #       i += 1
  #       this_date += 1 # or however you advance to the next day
  #       averages << {
  #         date: this_date - 1
  #         running_avg_prod: past_week.sum / 7.0
  #       }
  #     end
  #
  #  Note how an_interval.productivity just "worked",
  #       and group_by(_.date).sorted just "worked".
  #    The code for that in this file should actually be that simple.
  #    The code below has way too many temporary hashes.
  #    The code above has ZERO temporary hashes.
  #       It has much less crap and is mildly more efficient than that below.
  #       I think it will be much easier to cache what's going on above in
  #           some sort of caching layer.
  #
  #
  #  This is exactly the type of coding I hope to do more of in this project, so
  #     figuring out how to write it better is crucial.
  #
  #  As it stands, [hopefully, this method] starts with an array like
  #     [
  #       {:date, :task, :time_spent},
  #       ...
  #     ]
  #
  # 2. find the task, and get it's priority, to calculate
  #     [
  #       {:date, :productivity},
  #       ...
  #     ]
  #
  # 3. group-by date, to obtain
  #     {
  #       date_val => [
  #                     {:date, :productivity},
  #                     ...
  #                   ],
  #       ...
  #     }
  #
  # 4. get every date between start and today, and
  #    do the rolling average to obtain (sorted by :date)
  #     [
  #       { :date, :rolling_avg },
  #       ...
  #     ]
  #
  def weekly_productivity_per_day
    def productivity(value, priority)
      value * (1 + priority / 10.0)
    end
    time_per_days = tasks.flat_map { |t| t.time_per_day }

    first_date = Date.today
    last_date = Date.today

    # get a [{date, productivity}] array
    # also, find the first date
    step_2 = time_per_days.map do |h|
      this_date = Date.strptime(h[:date], d_fmt(:mdy))
      if this_date < first_date
        first_date = this_date
      end
      {
        date: this_date,
        productivity: productivity(
          h[:value],
          Task.find_by_name(h[:name]).priority
        )
      }
    end

    step_3 = step_2.group_by { |h| h[:date] }

    # fill missing dates with zeros (similar to the method fill_missing_dates, but not the same)
    # and get rolling avg result

    last_seven_arr = []
    result = []
    (0..(last_date-first_date).to_i).each do |day_offset|
      this_date = first_date+day_offset
      last_seven_arr <<
        # if this date has productivity data, sum it all up
        if step_3.has_key? this_date
          step_3[this_date].inject(0.0) { |s, a| s+a[:productivity] }
        else
          0.0
        end
      if last_seven_arr.count >= 7
        result << {
            date: this_date,
            rolling_avg: last_seven_arr[-7..-1].inject(0) { |s, a| s + a } / 7
        }
      end

      # optimization to save on memory, not surely useful
      # truncate the rolling-sum array once it gets long
      if last_seven_arr.count > 500
        last_seven_arr = last_seven_arr[-6..-1]
      end

    end
    result
  end
end
