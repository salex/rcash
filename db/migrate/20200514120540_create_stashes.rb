class CreateStashes < ActiveRecord::Migration[6.0]
  def change
    create_table :stashes do |t|
      t.references :stashable, polymorphic: true, null: false
      t.string :type
      t.date :date
      t.text :hash_data
      t.text :text_data
      t.text :slim
      t.text :yaml
      t.text :csv
      t.date :date_data
      t.string :status

      t.timestamps
    end
    add_index :stashes, :type
  end
end
