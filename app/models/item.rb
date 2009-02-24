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

  def self.find_items_per_count(letter)
    items = Item.find_all_by_first_kana_key(letter)
    items_per_count = {}
    items.each do |item|
      count = GameItem.find_all_by_item_id(item.id).size
      if count > 0
        items_per_count[count] ||= []
        items_per_count[count] << item
      end
    end
    items_per_count
  end

  def self.suggest_items(word, excepts)
    kana_key = ShiritoriEngine.new.kana_key(word.last)
    letter = candidate_letters(kana_key) if word
    ticket = 3
    items = []
    items_per_count = find_items_per_count(letter)
    counts_ordered = items_per_count.keys.sort.reverse
    counts_ordered.each do |count|
      items_per_count[count].each do |i|
        next if excepts.include? i
        items << i
        ticket -= 1
        break unless ticket > 0
      end
      break unless ticket > 0
    end
    items
  end

  def self.candidate_letters(word)
    ShiritoriEngine.new.candidates(word).join("、")
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
