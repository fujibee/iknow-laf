class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :score
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
