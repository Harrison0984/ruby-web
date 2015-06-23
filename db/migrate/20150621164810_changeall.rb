class Changeall < ActiveRecord::Migration
  def change
  	add_column :tasklogs, :taskdate, :date
  end
end
