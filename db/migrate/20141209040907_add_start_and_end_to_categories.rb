class AddStartAndEndToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :start_date, :datetime
    add_column :categories, :end_date, :datetime
  end
end
