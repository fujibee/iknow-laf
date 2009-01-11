class Game < ActiveRecord::Base

  attr_accessor :started, :history, :status, :failure_times

  def valid_answer?(item)
    result ||= "はずれ！" unless item
    result ||= "同じ言葉は使えません！" if history.include? item

    engine = ShiritoriEngine.new
    if item and not engine.valid_connection?(item.kana, last_item.kana)
      result ||= engine.errors.join(", ")
    end

    unless result.nil?
      @failure_times += 1
      @status = result
      false
    else
      true
    end
  end

  def last_item
    @history.last
  end
end
