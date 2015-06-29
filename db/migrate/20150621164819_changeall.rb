class Changeall < ActiveRecord::Migration
  def change
  	add_column :tracelogs, :mulbability, :float
  end
end
