class AddUrlToSubtask < ActiveRecord::Migration
  def change
    add_column :subtasks, :url, :text
  end
end
