class Game < ActiveRecord::Base

  attr_accessor :started, :history, :status

  def valid_answer?(item)
    return false unless item
    if item.kana.last == 'ん'
      @status = "「ん」では終われません！"
      return false
    end
    if history.include? item
      @status = "同じ言葉は使えません！"
      return false
    end
    unless last_item.kana.last == item.kana.first
      @status = "しりとりしてください！"
      return false
    end
    true
  end

  def last_item
    @history.last
  end
end
