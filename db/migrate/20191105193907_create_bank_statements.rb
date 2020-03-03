class CreateBankStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_statements do |t|
      t.references :book, null: false, foreign_key: true
      t.date :statement_date
      t.integer :beginning_balance
      t.integer :ending_balance
      t.text :ofx_data
      t.text :hash_data
      t.date :reconciled_date

      t.timestamps
    end
  end
end
