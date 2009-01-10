class Item < ActiveRecord::Base

  def self.find_and_register(spell)
    spell.downcase!
    item = find_by_spell(spell)
    unless item
      analyzer = TransliterationAnalyzer.new
      analyzer.analyze(spell)
      if analyzer.found
        analyzer.items.each do |i|
          i.save
          item ||= i
        end
      end
    end
    item
  end
end
