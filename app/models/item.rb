class Item < ActiveRecord::Base

  def self.find_and_register(spell)
    spell.downcase!
    item = find_by_spell(spell)
    unless item
      analyzer = TransliterationAnalyzer.new
      analyzer.analyze(spell)
      if analyzer.found
        item = create(:spell => spell, :kana => analyzer.kana,
                      :iknow_id => analyzer.iknow_id)
      end
    end
    item
  end
end
