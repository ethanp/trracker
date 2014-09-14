class AddTurnedinToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :turned_in, :boolean
  end
end
