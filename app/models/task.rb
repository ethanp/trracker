class Task < ActiveRecord::Base
  belongs_to :category
  has_many :subtasks, dependent: :destroy
  has_many :intervals, dependent: :destroy

  # add up all intervals
  def seconds_spent
    # 'inject' is the same as foldLeft
    self.intervals.inject(0){ |sum, interval| sum + interval.seconds_spent }.to_i
  end
  def heatmap_hash_array
    self.intervals.inject([]) { |arr, h| arr + h.heatmap_hash_array }
  end
end
