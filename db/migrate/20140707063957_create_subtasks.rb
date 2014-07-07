class CreateSubtasks < ActiveRecord::Migration
  def change
    create_table :subtasks do |t|
      t.references :task, index: true
      t.string :name
      t.boolean :complete

      t.timestamps
    end
  end
end
