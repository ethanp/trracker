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
    f = DateTime.strptime(dates.first, d_fmt(:mdy))
    l = DateTime.strptime(dates.last, d_fmt(:mdy))
    all_dates = (0..(l-f).to_i).map { |i| (f+i).strftime(d_fmt :mdy) }
    by_name = arr.group_by { |x| x[:name] }
    not_sure = all_dates.flat_map do |date|
      by_name.map do |name, objects|
        value_zero_hash = { date: date, name: name, value: 0 }
        objects.select{ |x| x[:date] == date }.give_default(value_zero_hash)
      end
    end
    not_sure.flatten.sort_by { |x| [x[:date], x[:name]] } # sort by date /then/ name
  end

  # 1. get an array like
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
  # 4. sum values to obtain
  #     [
  #       { :date, :value },
  #       ...
  #     ]
  #
  # 5. sort by date
  #
  # 6. fill missing dates with zeros
  #
  # 7. do the rolling average to obtain (sorted by :date)
  #     [
  #       { :date, :rolling_avg },
  #       ...
  #     ]
  #
  def weekly_productivity_per_day
    def productivity(value, priority)
      value * (1 + priority / 10.0)
    end
    step_1 = tasks.flat_map { |t| t.time_per_day }
    step_2 = step_1.map do |h|
      {
          date: h[:date],
          productivity: productivity(h[:value], Task.find_by_name(h[:name]).priority)
      }
    end
    step_3 = step_2.group_by { |h| h[:date] }
    step_4 = step_3.map do |k, v|
      {
          date: Date.strptime(k, d_fmt(:mdy)),
          value: v.inject(0) { |sum, a| sum + a[:productivity] }
      }
    end
    step_5 = step_4.sort_by { |h| h[:date] }

    # TODO step_6 = fill missing dates with zeros

    step_7 = (0..step_5.count-7).map do |i|
      last_seven_arr = step_5[i...i+7]
      {
          date: last_seven_arr.last[:date],
          rolling_avg: last_seven_arr.inject(0) { |sum, a| sum + a[:value] } / 7
      }
    end
    puts step_7
    step_7
  end
end
