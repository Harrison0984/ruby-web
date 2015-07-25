class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account
      t.string :password
      t.string :nickname
      t.integer :coin
      t.integer :level
      t.integer :action
      t.string :regionname
      t.integer :lowerlimit
      t.integer :upperlimit
      t.integer :everylimit
      t.integer :todaycoin

      t.timestamps null: false
    end
  end
end
