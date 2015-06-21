class Changeall < ActiveRecord::Migration
  def change
  	rename_column :tracelogs, :type, :gametype
  end
end
