class Subtask < ActiveRecord::Base
  belongs_to :task

  # validations
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:task_id]
  validates_length_of :name, maximum: 60, too_long: 'That name is too long (60 chars max)'
end
