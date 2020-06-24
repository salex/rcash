class CreateSalesItems < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_items do |t|
      t.string :name
      t.string :type
      t.float :price
      t.float :cost
      t.string :department
      t.float :markup
      t.integer :quanity
      t.integer :alert
      t.integer :size
      t.integer :cases
      t.integer :bottles
      t.integer :bottles_1
      t.string :bottles_2
      t.integer :percent

      t.timestamps
    end
  end
end
