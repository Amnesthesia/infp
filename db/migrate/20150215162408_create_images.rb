class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :path
      t.boolean :profile_picture
      t.references :resource, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
