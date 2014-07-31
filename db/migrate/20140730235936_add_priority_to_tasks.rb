class AddPriorityToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :priority, :integer

    Task.reset_column_information
    reversible do |dir|
      dir.up { Task.update_all priority: 0 }
    end

    change_column :tasks, :priority, :integer, null: false

  end
end
