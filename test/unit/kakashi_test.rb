require 'test_helper'

class KakasiTest < ActiveSupport::TestCase

  import 'java.lang.System'
  import 'com.kawao.kakasi.Kakasi'

  def test_kakasi
    System.set_property('kakasi.kanwaDictionary',
      File.expand_path(File.dirname(__FILE__) + "../../../config/kanwadict"))

    kakasi = Kakasi.new
    kakasi.setup_kanji_converter(Kakasi::HIRAGANA)
    kakasi.setup_katakana_converter(Kakasi::HIRAGANA)
    assert_equal "おこめ", kakasi.do_string("お米")
    assert_equal "たいがー", kakasi.do_string("タイガー")
  end

end
