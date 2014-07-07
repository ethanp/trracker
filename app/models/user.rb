class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :categories, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def tasks
    categories.flat_map { |c| c.tasks }
  end

  def subtasks
    tasks.flat_map { |t| t.subtasks }
  end
end
