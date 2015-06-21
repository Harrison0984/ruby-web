class CreateTasklogs < ActiveRecord::Migration
  def change
    create_table :tasklogs do |t|
      t.integer :totalbar
      t.integer :currentbar
      t.integer :errorbar
      t.integer :totalprizes
      t.integer :dayprizes
      t.integer :totalmoney
      t.integer :prizemoney
      t.datetime :runtime

      t.timestamps null: false
    end
  end
end
