class CreateRevenue < ActiveRecord::Migration[6.0]
  def change
    create_table :revenues do |t|
      t.references :deposit, null: false, foreign_key: true
      t.string :type
      t.string :item
      t.integer :quanity, default: 0
      t.float :amount, default: 0.0
      t.string :remarks
    end
  end
end
