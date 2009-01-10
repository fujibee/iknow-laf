class TransliterationAnalyzer

  attr_reader :found, :items

  def initialize
    @items = []
  end

  def analyze(en_word)
    options = {:include_sentences => true, :part_of_speech => 'n'}
    candidates = Iknow::Item.matching(en_word, options)
    candidates.each do |iknow_item|
      next unless iknow_item.responses
      next unless en_word == iknow_item.cue.text
      item = Item.new(:spell => en_word)
      ja_word = iknow_item.responses.first
      if ja_word and ja_word.type == 'meaning'
        kana = KakasiAdapter.new.to_hiragana(ja_word.text)
        unless kana.empty?
          item.kana = kana
          item.iknow_id = iknow_item.id
          @items << item if item.save
          @found = true
        end
      end
    end
  end

end
