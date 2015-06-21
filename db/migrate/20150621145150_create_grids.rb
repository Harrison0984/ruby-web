class CreateGrids < ActiveRecord::Migration
  def change
    create_table :grids do |t|
      t.integer :x1
      t.integer :x2
      t.integer :x3
      t.integer :y1
      t.integer :y2
      t.integer :y3
      t.integer :z1
      t.integer :z2
      t.integer :z3
      t.datetime :time

      t.timestamps null: false
    end
  end
end
