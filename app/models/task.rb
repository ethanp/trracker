class Task < ActiveRecord::Base

  belongs_to :category
  has_many :subtasks, dependent: :destroy
  has_many :intervals, -> { order('start') }, dependent: :destroy

  # validations
  validates_presence_of   :name, :category_id, :priority
  validates_uniqueness_of :name, scope: [:category_id]
  validates_length_of     :name, maximum: 60, too_long: 'That name is too long (60 chars max)'

  # scopes
  # ######
  # These are saved SQL queries that allow you to do
  #   Task.due_within_two_weeks
  # to retrieve all tasks that fit the criteria

  scope :due_within_two_weeks, -> {
    where("tasks.duedate > ? AND tasks.duedate < ?",
          DateTime.now, 2.weeks.from_now.to_date)
  }
  scope :due_before, ->(datetime) {
    where("tasks.duedate > ? AND tasks.duedate < ?",
          DateTime.now, datetime)
  }
  scope :complete,     -> { where('tasks.complete = ?', true) }
  scope :incomplete,   -> { where("tasks.complete = ? OR tasks.complete IS NULL", false) }
  scope :turned_in,    -> { where('tasks.turned_in = ?', true) }
  scope :current_user, -> { where('tasks.user_id = ?', current_user.id) }

  def incomplete_subtasks
    Subtask.incomplete_for(self)
  end

  ### TODO maybe this should all be more "object oriented"

  #  total seconds spent on this task EVER
  # @return object of type Second
  #
  def seconds_spent
    # this is a fold_left
    self.intervals.inject(0) do
        |sum, interval| sum + interval.seconds_spent
    end.to_i.seconds
  end

  # collect all intervals' hash-representations into one array
  # => [
  #   {day: int[0..6], date:str['%m/%d/%Y'], hour: int[1..24], value: float[0..1]},
  #   ...
  # ]
  #
  def heatmap_base_data
    self.intervals.inject([]) do
      |arr, h| arr + h.heatmap_hash_array
    end
  end

  # this is the heatmap_base_data (above), but
  # summed by :day and :hour to produce
  # => [
  #   {day:int[0..6], hour:int[1..24], value:float[nil,0..]},
  #   ...
  # ]
  #
  # code from stackoverflow.com/questions/18421422
  #
  def final_heatmap_data

    # {[day, hour] => [{hash1}, {hash2}, ...], ... }
    grouped = self.heatmap_base_data.group_by do |elem|
      elem.values_at :day, :hour # this gives you [day, hour]
    end

    grouped.map do |(day, hour), elem|

      # turn that into {[d, h] => [v1, v2, ...], ... }
      values = elem.map{ |p| p[:value] }

      # if the list is non empty we sum it up, otherwise leave it as nil
      value = values.all? ? values.reduce(:+) : nil

      # and create a new array elem out of it for the d3 chart
      { day: day, hour: hour, value: value }
    end
  end

  # 2.1.2 :043 > Task.first.time_per_day
  # => [
  #   {:date=>"07/21/2014", :name=>"Anoath", :value=>0.0775},
  #   {:date=>"07/24/2014", :name=>"Anoath", :value=>0.0008333333333333334},
  #   {:date=>"10/04/2014", :name=>"Anoath", :value=>0.16722222222222222}
  # ]
  #
  def time_per_day
    self.heatmap_base_data.group_by_date_and_sum_hours(self)
  end

  # returns num seconds of class Seconds
  # sometimes just having static types is nice
  # i.e. a *comment* feels like the wrong place to document a function's return type
  def seconds_spent_today
    def hours_to_seconds(d)
      d * 60 * 60
    end

    today_str = Date.today.strftime(d_fmt :mdy)
    todays_hash = self.time_per_day.select { |h| h[:date] == today_str }

    if todays_hash.empty?
      0.seconds
    else
      # today's hash is an array with up to one value
      # it is in units of hours, so we convert to seconds
      hours_to_seconds( todays_hash.first[:value] ).seconds
    end
  end

  # e.g. duedate = my_task.duedate_as_datetime
  # @returns :: either the date or nil
  def duedate_as_datetime
    if self.duedate.nil?
      nil
    else
      DateTime.parse(self.duedate.to_s)
    end
  end

  # float
  def duedate_distance_in_days
    if self.duedate.nil?
      nil
    else
      (self.duedate_as_datetime - DateTime.now).to_f
    end
  end

  # bool
  def due_within_a_week
    if self.duedate.nil?
      false
    else
      self.duedate_distance_in_days < 7
    end
  end

  def turned_in_css_class
    if self.turned_in
      'turned-in'
    else
      'not-turned-in'
    end
  end
end
