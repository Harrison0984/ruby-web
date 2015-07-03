class Changeall < ActiveRecord::Migration
  def change
  	add_column :tasklogs, :nexttime, :datetime
  end
end
