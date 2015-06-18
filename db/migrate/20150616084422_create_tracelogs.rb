class CreateTracelogs < ActiveRecord::Migration
  def change
    create_table :tracelogs do |t|
      t.integer :type
      t.integer :pos
      t.integer :coin
      t.datetime :time
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
