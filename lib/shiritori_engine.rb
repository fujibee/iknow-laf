class ShiritoriEngine

  # TODO It should be singleton. To do so, have to remove @error attribution.

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

  def validate_connection(last_word, first_word)
    @errors = []
    @errors << "「ん」では終われません！" if first_word.last == 'ん'
    @errors << "しりとりになっていません！" unless valid_connection?(last_word, first_word)
    @errors.size == 0
  end

  def candidates(candidate_word)
    letter = last_letter(candidate_word)
    DUP_KANA.each do |key, value|
      return [letter, key] if value.include? letter
    end
    [letter]
  end

  def kana_key(word)
    letter = word.first
    DUP_KANA.each do |key, value|
      return key if value.include? letter
    end
    letter
  end

  private

  def valid_connection?(last_word, first_word)
    first_word_candidats = candidates(last_letter(last_word))
    first_word_candidats.include? first_word.first
  end

  def last_letter(last_word)
    if last_word.last == 'ー'
      last_word_mb = last_word.split(//)
      last_word_mb[last_word_mb.length - 2]
    else
      last_word.last
    end
  end

end
