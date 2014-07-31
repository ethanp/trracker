class Category < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, -> { order('duedate') },  dependent: :destroy

  # validations
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:user_id]
  validates_length_of :name, maximum: 30, too_long: 'That name is too long (30 chars max)'

  # { :date, :name (category.name), :value }
  def time_per_task_per_day

    # time_per_day : #<Array> of { :date, :task, :value }
    self.tasks.flat_map { |x| x.time_per_day }.todo_name(self)
  end
end
