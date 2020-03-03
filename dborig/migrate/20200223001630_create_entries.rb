class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.string :numb
      t.date :post_date
      t.string :description
      t.string :fit_id

      t.timestamps
    end
  end
end
