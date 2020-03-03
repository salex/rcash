class AddUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :full_name
      t.string :roles
      t.string :password_digest

      t.timestamps
    end

  end
end
