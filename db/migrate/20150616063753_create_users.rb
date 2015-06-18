class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account
      t.string :password
      t.string :nickname
      t.integer :coin

      t.timestamps null: false
    end
  end
end
