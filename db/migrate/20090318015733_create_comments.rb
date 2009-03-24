class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.string :user_name
      t.string :url
      t.string :mail

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
