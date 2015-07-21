class Changeall < ActiveRecord::Migration
  def change
  	add_column :users, :todaycoin, :integer
  	add_column :users, :everylimit, :integer
  end
end
