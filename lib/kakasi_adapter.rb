class KakasiAdapter
  import 'java.lang.System'
  import 'com.kawao.kakasi.Kakasi'

  def initialize
    System.set_property('kakasi.kanwaDictionary', "#{RAILS_ROOT}/config/kanwadict")
    @kakasi = Kakasi.new
    @kakasi.setup_kanji_converter(Kakasi::HIRAGANA)
    @kakasi.setup_katakana_converter(Kakasi::HIRAGANA)
  end

  def to_hiragana(text)
    @kakasi.do_string(text)
  end
end
