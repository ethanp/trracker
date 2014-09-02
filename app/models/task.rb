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

  def seconds_spent
    self.intervals.inject(0) { |sum, interval| sum + interval.seconds_spent }.to_i
  end

  # collect all intervals' hash-representations into one array
  def heatmap_hash_array
    self.intervals.inject([]) { |arr, h| arr + h.heatmap_hash_array }
  end

  # { :date, :name (task.name), :value }
  def time_per_day
    self.heatmap_hash_array.group_by_date_and_sum_by_value(self)
  end

  def pressing_duedate
    if not self.duedate.nil?
      due = DateTime.parse(self.duedate.to_s)
      distance = (due - DateTime.now).to_f
      case distance
        when 0..3
          "danger"
        when 3..7
          "warning"
      end
    end
  end
end
