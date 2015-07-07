class CreateTasklogs < ActiveRecord::Migration
  def change
    create_table :tasklogs do |t|
      t.integer :totalbar
      t.integer :currentbar
      t.integer :errorbar
      t.integer :totalcoin
      t.integer :prizecoin
      t.datetime :runtime
      t.datetime :nexttime
      t.datetime :taskdate

      t.timestamps null: false
    end
  end
end
