class CreateLoginlogs < ActiveRecord::Migration
  def change
    create_table :loginlogs do |t|

      t.string :username
      t.integer :action
      t.datetime :time

      t.timestamps null: false
    end
  end
end
