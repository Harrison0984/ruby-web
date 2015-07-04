class Changeall < ActiveRecord::Migration
  def change
  	add_column :tracelogs, :action, :integer
  end
end
