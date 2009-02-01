class AddFirstKanaKeyToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :first_kana_key, :string
    add_index :items, :first_kana_key
    se = ShiritoriEngine.new
    Item.find(:all).each do |i|
      i.first_kana_key = se.kana_key(i.kana.first)
      i.save
    end
  end

  def self.down
    remove_index :items, :first_kana_key
    remove_column :items, :first_kana_key
  end
end
