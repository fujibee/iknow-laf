class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :spell
      t.string :meaning
      t.string :kana
      t.integer :iknow_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
