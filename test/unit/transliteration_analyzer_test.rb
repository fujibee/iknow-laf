require 'test_helper'

class TransliterationAnalyzerTest < ActiveSupport::TestCase

  def test_simple
    a = TransliterationAnalyzer.new
    a.analyze("Apple")
    a.analyze("Lion")
    a.analyze("Tiger")
    a.analyze("Mint")
    a.analyze("Soy source")
  end
end
