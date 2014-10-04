class Task < ActiveRecord::Base
  belongs_to :category
  has_many :subtasks, dependent: :destroy
  has_many :intervals, -> { order('start') }, dependent: :destroy

  # validations
  validates_presence_of :name, :category_id, :priority
  validates_uniqueness_of :name, scope: [:category_id]
  validates_length_of :name, maximum: 60, too_long: 'That name is too long (60 chars max)'

  scope :due_within_two_weeks, -> {
    where("tasks.duedate > ? AND tasks.duedate < ?",
          DateTime.now, 2.weeks.from_now.to_date)
  }
  scope :due_before, ->(datetime) {
    where("tasks.duedate > ? AND tasks.duedate < ?",
          DateTime.now, datetime)
  }
  scope :complete, -> { where('tasks.complete = ?', true) }
  scope :incomplete, -> { where("tasks.complete = ? OR tasks.complete IS NULL", false) }
  scope :turned_in, -> { where('tasks.turned_in = ?', true) }

  def seconds_spent
    self.intervals.inject(0) {
        |sum, interval| sum + interval.seconds_spent
    }.to_i.seconds
  end

  # collect all intervals' hash-representations into one array
  def heatmap_hash_array
    self.intervals.inject([]) { |arr, h| arr + h.heatmap_hash_array }
  end

  # { date: '%m/%d/%y', name: task.name, value: hours }
  def time_per_day
    self.heatmap_hash_array.group_by_date_and_sum_by_value(self)
  end


  # returns num seconds of class Seconds
  # sometimes just having static types is nice.
  def seconds_spent_today
    today_str = Date.today.strftime('%m/%d/%y')
    todays_hash = self.time_per_day.select { |h| h[:date] == today_str }

    if todays_hash.empty?
      0.seconds
    else
      # today's hash is an array with up to one value
      # it is in units of hours, so we convert to seconds
      total = todays_hash.first[:value] * 60 * 60
      total.seconds
    end
  end

  def duedate_as_datetime
    return nil if self.duedate.nil?
    DateTime.parse(self.duedate.to_s)
  end

  def duedate_distance_in_days
    return nil if self.duedate.nil?
    (self.duedate_as_datetime - DateTime.now).to_f
  end

  def due_within_a_week
    return false if self.duedate.nil?
    return self.duedate_distance_in_days < 7
  end

  def index_css_class
    if self.turned_in
      nil
    elsif self.complete
      "success"
    elsif self.duedate.nil?
      nil
    elsif self.duedate_distance_in_days < 0
      "danger"
    else
      case self.duedate_distance_in_days
        when 0..3
          "warning"
        when 3..7
          "info"
      end
    end
  end

  def turned_in_css_class
    self.turned_in ? 'turned-in' : 'not-turned-in'
  end
end
