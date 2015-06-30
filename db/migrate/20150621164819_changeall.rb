class Changeall < ActiveRecord::Migration
  def change
  	change_column :tracelogs, :mulbability, :float
  end
end
