class TransliterationAnalyzer

  attr_reader :found, :items

  def initialize
    @items = []
  end

  def analyze(en_word)
    options = {:include_sentences => true, :part_of_speech => 'n'}
    kakasi = KakasiAdapter.new
    candidates = Iknow::Item.matching(en_word, options)
    candidates.each do |iknow_item|
      next unless iknow_item.responses
      next unless en_word.downcase == iknow_item.cue.text.downcase
      next unless iknow_item.creator.downcase == 'cerego'

      res = iknow_item.responses.first
      if res and res.type == 'meaning'
        meanings = split_seps(res.text)
        meanings.each do |meaning|
          item = Item.new(:spell => en_word)
          kana = kakasi.to_hiragana(meaning)
          unless kana.empty?
            item.kana = kana
            item.first_kana_key = ShiritoriEngine.new.kana_key(item.kana.first)
            item.meaning = meaning
            item.iknow_id = iknow_item.id
            @items << item
            @found = true
          end
        end
      # if break here, first word only..
      end
    end
  end

  private

  # split "、" and ", " because of mixing Japanese
  def split_seps(text)
    list = text.split(/、/)
    list.map {|i| i.split(/, /)}.flatten
  end

end
