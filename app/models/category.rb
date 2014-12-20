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

  # [
  #   {
  #     :date ("mm/dd/yy"),
  #     :name (this_category's.name),
  #     :value (hours:Double)
  #   }
  # ]     # sorted by :date
  def time_per_day
    # time_per_day : #<Array> of { :date, :task, :value }
    self.tasks.flat_map { |x| x.time_per_day }.group_by_date_and_sum_hours(self)
  end

  # bool
  def has_task_due_within_a_week
    self.tasks.incomplete.select{ |t| t.due_within_a_week }.size > 0
  end

  # bool
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
    first_date = Date.strptime(time_per_day.first[:date], "%m/%d/%y")
    last_date = self.end_date.nil? ? Date.today : self.end_date.to_date
    num_days = (last_date - first_date).to_i
    return 0 if num_days < 0
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
