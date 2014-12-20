class Subtask < ActiveRecord::Base
  belongs_to :task

  # validations
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:task_id]
  validates_length_of :name, maximum: 60, too_long: 'That name is too long (60 chars max)'

  # the parameters at the end are for filling in the "?"s
  scope :incomplete_for, ->(task) {
    where("(subtasks.complete = ? OR subtasks.complete IS NULL) AND subtasks.task_id = ?",
          false, task)
  }
end
