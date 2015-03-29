class Category < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, -> { order('duedate') },  dependent: :destroy

  # gives us an ActiveRecord getter for all the intervals belonging to this Category
  # In particular:
  #     SELECT "intervals".*
  #     FROM "intervals" INNER JOIN "tasks"
  #     ON "intervals"."task_id" = "tasks"."id"
  #     WHERE "tasks"."category_id" = ?   % ? := this category's ID
  #     ORDER BY start, duedate
  has_many :intervals, through: :tasks

  # validations
  validates_presence_of :name
  validates_presence_of :user_id
  validates_uniqueness_of :name, scope: [:user_id]
  validates_length_of :name, maximum: 30, too_long: 'That name is too long (30 chars max)'

  # @returns the following array (sorted by :date)
  # Array[
  #   Hash{
  #     :date ("mm/dd/yy"),
  #     :name (this_category's.name),
  #     :value (hours:Double)
  #   }
  # ]
  def time_per_day
    # time_per_day : #<Array> of { :date, :task, :value }
    self.tasks.flat_map { |x| x.time_per_day }.group_by_date_and_sum_hours(self)
  end

  def has_task_due_within_a_week
    self.tasks.incomplete.select{ |t| t.due_within_a_week }.size > 0
  end

  def has_date_bounds
    !(self.start_date.nil? || self.end_date.nil?)
  end

  def has_ended
    self.has_date_bounds && Date.today > self.end_date
  end

  def has_started
    self.has_date_bounds && Date.today > self.start_date
  end

  # double
  # this currently adds up the total number of time spent on this task
  # and divides by the number of days since its first-recorded-interval
  # no idea if the arithmetic on the version WITH an end-date is actually performed as planned
  # TODO this could REALLY use some testing
  def avg_secs_per_day
    # array created above has first interval, so we can find the first date
    # but it's string-formatted at this point
    return 0 if tasks.count == 0 or intervals.count == 0
    first_date = Date.strptime(time_per_day.first[:date], d_fmt(:mdy))
    no_end_date = self.end_date.nil?
    hasnt_ended = Date.today < self.end_date unless no_end_date
    last_date = (no_end_date or hasnt_ended) ? Date.today : self.end_date.to_date
    num_days = (last_date - first_date).to_i
    return 0 unless num_days > 0
    hrs = time_per_day.inject(0) { |sum, h| sum + h[:value] }
    secs = hrs * 60 * 60
    return secs / num_days
  end

  def first_incomplete_task
    self.tasks.incomplete.select{ |t| !t.duedate.nil? }.first || self.tasks.incomplete.first
  end
  def first_incomplete_duedate
    self.first_incomplete_task.duedate
  end

end

# this is used above
class Array
  # the resulting array is also sorted by date ascending
  def group_by_date_and_sum_hours(a_category)
    # for each set of hashes belonging to a particular date
    arr = self.group_by { |x| x[:date] }.values.map do |x|
      # add up the total number of hours for that date
      sum = x.inject(0.0) { |sum, hash| sum + hash[:value] }
      # make a (single) new hash for this date with the sum of this category's hours
      { date: x.first[:date], name: a_category.name, value: sum }
    end
    arr.sort_by { |x| Date.strptime(x[:date], d_fmt(:mdy)) }
  end

  def to_ids
    self.map { |x| x.id }
  end

  # this parameter should be lazily evaluated
  def give_default(default)
    self.empty? ? self << default : self
  end
end
