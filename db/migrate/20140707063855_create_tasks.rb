class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :complete
      t.datetime :duedate
      t.references :category, index: true

      t.timestamps
    end
  end
end
