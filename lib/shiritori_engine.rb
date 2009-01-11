class ShiritoriEngine

  attr_reader :errors

  def initialize
    @errors = []
  end

  def valid_connection?(last_word, first_word)
    @errors << "「ん」では終われません！" if first_word.last == 'ん'
    @errors << "しりとりになっていません！" unless last_word.last == first_word.first
    @errors.size == 0
  end

end
