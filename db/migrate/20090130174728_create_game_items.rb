class CreateGameItems < ActiveRecord::Migration
  def self.up
    create_table :game_items do |t|
      t.integer :game_id
      t.integer :item_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :game_items
  end
end
