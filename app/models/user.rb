class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :categories, dependent: :destroy

  # this was so crucial, because now I get #<ActiveRecord::Association> instead of #<Array>
  # which means I can apply the scope "tasks.complete" which would have required filtering
  # an array which would have been much slower.
  has_many :tasks, through: :categories
  has_many :subtasks, through: :tasks
  has_many :intervals, through: :tasks

  def full_name
    "#{first_name} #{last_name}"
  end

  # for each category, have the total amount of time for each day
  def time_per_category_per_day
    times_per_category = self.categories.flat_map { |x| x.time_per_task_per_day }
    fill_missing_dates times_per_category
  end

  private

  # for every date where a name doesn't have a value,
  # create a data-point with value 0
  #
  def fill_missing_dates(arr)
    # arr is an array of these: { :date, :name (category.name), :value }
    dates = arr.map { |x| x[:date] }
    f = DateTime.strptime(dates.first, "%m/%d/%y")
    l = DateTime.strptime(dates.last, "%m/%d/%y")
    all_dates = (0..(l-f).to_i).map { |i| (f+i).strftime("%m/%d/%y") }
    by_name = arr.group_by { |x| x[:name] }
    not_sure = all_dates.flat_map do |date|
      by_name.map do |name, objects|
        value_zero_hash = { date: date, name: name, value: 0 }
        objects.select{ |x| x[:date] == date }.give_default(value_zero_hash)
      end
    end
    not_sure.flatten.sort_by { |x| [x[:date], x[:name]] } # sort by date /then/ name
  end
end
class Array

  # TODO this should go in a /helper/ or something, no?
  # the resulting array is also sorted by date ascending
  def group_by_date_and_sum_by_value(parent_instance)
    arr = self.group_by { |x| x[:date] }.values.map do |x|
      sum = x.inject(0.0) { |sum, hash| sum + hash[:value] }
      { date: x.first[:date], name: parent_instance.name, value: sum }
    end
    arr.sort_by { |x| x[:date] }
  end

  def to_ids
    self.map { |x| x.id }
  end

  # this parameter should be lazily evaluated
  def give_default(default)
    self.empty? ? self << default : self
  end
end
