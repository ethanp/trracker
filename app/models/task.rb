class Task < ActiveRecord::Base
  belongs_to :category
  has_many :subtasks, dependent: :destroy
  has_many :intervals, dependent: :destroy
end
