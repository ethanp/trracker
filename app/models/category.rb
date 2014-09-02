class Category < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, -> { order('duedate') },  dependent: :destroy

  # validations
  validates_presence_of :name
  validates_presence_of :user_id
  validates_uniqueness_of :name, scope: [:user_id]
  validates_length_of :name, maximum: 30, too_long: 'That name is too long (30 chars max)'

  # { :date, :name (category.name), :value }
  def time_per_task_per_day

    # time_per_day : #<Array> of { :date, :task, :value }
    self.tasks.flat_map { |x| x.time_per_day }.group_by_date_and_sum_by_value(self)
  end
  def has_task_due_in_a_week
    self.tasks.incomplete.select{ |t| t.pressing_duedate }.size > 0
  end

  def first_incomplete_task
    self.tasks.incomplete.first
  end
  def first_incomplete_duedate
    self.first_incomplete_task.duedate
  end
end
