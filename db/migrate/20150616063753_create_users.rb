class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account
      t.string :password
      t.string :nickname
      t.integer :coin
      t.integer :level
      t.integer :action
      t.integer :regionid
      t.integer :lowerlimit
      t.integer :upperlimit

      t.timestamps null: false
    end
  end
end
