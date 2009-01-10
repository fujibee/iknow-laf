class TransliterationAnalyzer

  attr_reader :kana, :iknow_id, :found

  def analyze(en_word)
    options = {:include_sentences => true, :part_of_speech => 'n'}
    candidates = Iknow::Item.matching(en_word, options)
    candidates.each do |i|
      next unless i.responses
      ja_word = i.responses.first
      if ja_word and ja_word.type == 'meaning'
        @kana = KakasiAdapter.new.to_hiragana(ja_word.text)
        unless @kana.empty?
          @iknow_id = i.cue.id
          @found = true
          break
        end
      end
    end
  end

end
