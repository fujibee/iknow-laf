require 'test_helper'

class TransliterationAnalyzerTest < ActiveSupport::TestCase

  def test_simple
    a = TransliterationAnalyzer.new
    #["Apple", "Lion", "Tiger" "Mint", "Soy source"].each do |i|
    ["tiger"].each do |i|
      a.analyze(i)
      p a.items
    end
  end
end
