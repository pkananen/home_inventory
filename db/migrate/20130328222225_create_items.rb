class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :model
      t.datetime :purchasedate
      t.integer :quantity
      t.string :serialnum
      t.string :location

      t.timestamps
    end
  end
end
