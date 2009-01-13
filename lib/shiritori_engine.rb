class ShiritoriEngine

  attr_reader :errors

  DUP_KANA = {
    'あ' => ['ぁ'], 'い' => ['ぃ'], 'う' => ['ぅ'], 'え' => ['ぇ'], 'お' => ['ぉ'],
    'か' => ['が'], 'き' => ['ぎ'], 'く' => ['ぐ'], 'け' => ['げ'], 'こ' => ['ご'],
    'さ' => ['ざ'], 'し' => ['じ'], 'す' => ['ず'], 'せ' => ['ぜ'], 'そ' => ['ぞ'],
    'た' => ['だ'], 'ち' => ['ぢ'], 'つ' => ['づ', "っ"], 'て' => ['で'],
    'と' => ['ど'],
    'は' => ['ば', 'ぱ'], 'ひ' => ['び', 'ぴ'], 'ふ' => ['ぶ', 'ぷ'],
    'へ' => ['べ', 'ぺ'], 'ほ' => ['ぼ', 'ぽ'],
    'や' => ['ゃ'], 'ゆ' => ['ゅ'], 'よ' => ['ょ'], 'わ' => ['ゎ']
  }

  def initialize
    @errors = []
  end

  def valid?(last_word, first_word)
    @errors << "「ん」では終われません！" if first_word.last == 'ん'
    @errors << "しりとりになっていません！" unless valid_connection?(last_word, first_word)
    @errors.size == 0
  end

  def candidates(letter)
    dup_kana_all = DUP_KANA.keys.map {|k| [k].concat(DUP_KANA[k])}
    dup_kana_all.each do |dk|
      return dk if dk.include? letter
    end
  end

  private

  def valid_connection?(last_word, first_word)
    first_word_candidats = candidates(first_word.first)
    first_word_candidats.include? last_word.last
  end

end
