class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.references :user, index: true
      t.boolean :is_admin

      t.timestamps null: false
    end
    add_foreign_key :users, :users
  end
end
