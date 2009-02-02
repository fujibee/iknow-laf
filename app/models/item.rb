class Item < ActiveRecord::Base

  has_many :game_items
  has_many :games, :through => :game_items

  def self.find_and_register(spell)
    spell.downcase!
    items = find_all_by_spell(spell)
    if items.empty?
      analyzer = TransliterationAnalyzer.new
      analyzer.analyze(spell)
      if analyzer.found
        items = analyzer.items
        items.each {|i| i.save}
      end
    end
    items
  end

  def self.all_kana_keys
    candidates = Item.find_by_sql("SELECT DISTINCT first_kana_key FROM items")
    candidates.select {|i| 'あ' <= i.first_kana_key and i.first_kana_key <= 'ん'}
  end

  def display_name
    s = spell
    s += " #{meaning}[#{kana}]" if kana and meaning
    s
  end
end
