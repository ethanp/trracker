class CreateIntervals < ActiveRecord::Migration
  def change
    create_table :intervals do |t|
      t.datetime :start
      t.datetime :end
      t.references :task, index: true

      t.timestamps
    end
  end
end
