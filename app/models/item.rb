class Item < ActiveRecord::Base

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

  def display_name
    s = spell
    s += " #{meaning}[#{kana}]" if kana and meaning
    s
  end
end
