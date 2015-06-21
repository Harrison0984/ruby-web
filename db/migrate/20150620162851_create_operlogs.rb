class CreateOperlogs < ActiveRecord::Migration
  def change
    create_table :operlogs do |t|
      t.string :maname
      t.string :username
      t.integer :coin
      t.integer :action
      t.datetime :time

      t.timestamps null: false
    end
  end
end
