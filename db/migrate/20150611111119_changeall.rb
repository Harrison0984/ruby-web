class Changeall < ActiveRecord::Migration
  def change
  	add_column :tracelogs, :usercoin, :integer
  end
end
