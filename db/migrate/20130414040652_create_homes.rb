class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :name
      t.string :location
      t.string :type
      t.integer :user_id

      t.timestamps
    end
    add_index :homes, :user_id
  end
end
