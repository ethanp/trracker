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
    self.categories.map { |x| x.time_per_task_per_day }
  end
end
