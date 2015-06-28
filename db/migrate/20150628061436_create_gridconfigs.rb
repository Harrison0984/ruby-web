class CreateGridconfigs < ActiveRecord::Migration
  def change
    create_table :gridconfigs do |t|
    	t.integer :gridtype
    	t.float :probability
    	t.float :mulbability

      t.timestamps null: false
    end
  end
end
