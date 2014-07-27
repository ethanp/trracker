class Task < ActiveRecord::Base
  belongs_to :category
  has_many :subtasks, dependent: :destroy
  has_many :intervals, -> { order('start') }, dependent: :destroy

  # validations
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:category_id]
  validates_length_of :name, maximum: 30, too_long: 'That name is too long (30 chars max)'

  # scopes (enables e.g. Task.due_within_two_weeks)
  scope :due_within_two_weeks, -> {
    where("tasks.duedate > ? AND tasks.duedate < ?",
          DateTime.now, 2.weeks.from_now.to_date)
  }
  scope :due_before, ->(datetime) {
    where("tasks.duedate > ? AND tasks.duedate < ?",
          DateTime.now, datetime)
  }

  def seconds_spent
    self.intervals.inject(0){ |sum, interval| sum + interval.seconds_spent }.to_i
  end
  def heatmap_hash_array
    self.intervals.inject([]) { |arr, h| arr + h.heatmap_hash_array }
  end
end
