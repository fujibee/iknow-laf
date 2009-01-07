class TransliterationAnalyzer

  attr_reader :kana, :iknow_id, :found

  def analyze(en_word)
    Iknow::Config.init do |conf|
      conf.format = 'xml'
    end

    options = {:include_sentences => true, :part_of_speech => 'n'}
    candidates = Iknow::Item.matching(en_word, options)
    candidates.each do |i|
      next unless i.responses
      ja_word = i.responses.first
      if ja_word and ja_word.type == 'meaning'
        p "ja_word: #{ja_word.text}"
        @kana = to_kana(ja_word.text)
        p "kana: #{@kana}"
        unless @kana.empty?
          @iknow_id = i.cue.id
          @found = true
          break
        end
      end
    end
  end

  private

  HIRAGANA_START = "ぁ"
  HIRAGANA_END = "ん"
  KATAKANA_START = "ァ"
  KATAKANA_END = "ン"
  
  def to_kana(text)
    p "text=#{text}"
    kana = ""
    text.each_char do |c|
      if katakana? c
        kana += c
        # カタカナのみ対応
#      elsif hiragana? c
#        kana += hiragana_to_katakana(c)
      else; break end
    end
    kana
  end
  
  def init_kana
    @all_katakana = []
    k = KATAKANA_START
    100.times do
      p k
      @all_katakana << k
      k.succ!
      break if k == KATAKANA_END
    end
    @all_hiragana = []
    h = HIRAGANA_START
    100.times do
      p h
      @all_hiragana << h
      h.succ!
      break if h == HIRAGANA_END
    end
    @kana_inited = true
  end

  def katakana?(s); s =~ /^[#{KATAKANA_START}-#{KATAKANA_END}]+$/ end

  def hiragana?(s); s =~ /^[#{HIRAGANA_START}-#{HIRAGANA_END}]+$/ end

  def hiragana_to_katakana(h)
    init_kana unless @kana_inited
    p "hiragana=#{h}"
    p @all_katakana[@all_hiragana.index(h)]
    @all_katakana[@all_hiragana.index(h)]
  end

end
