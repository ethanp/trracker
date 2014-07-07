class ChangeNotNullEtcUser < ActiveRecord::Migration
  def change

    # oops forgot about the admin
    add_column :users, :admin, :boolean

    # make sure future id's are not null
    change_column_null( :tasks,     :category_id, false )
    change_column_null( :subtasks,  :task_id,     false )
    change_column_null( :categories,  :user_id,        false )
    change_column_null( :intervals, :task_id,   false )



    # side task: make sure names are not null either
    change_column_null( :tasks,       :name,        false)
    change_column_null( :subtasks,    :name,        false )
    change_column_null( :categories,  :name,        false )

    change_column_null( :users,       :first_name,  false )
    change_column_null( :users,       :last_name,   false )

    change_column_null( :intervals, :start, false )
    change_column_null( :intervals, :end,   false )
  end
end
