class Game < ActiveRecord::Base

  attr_accessor :started, :history, :status, :failure_times

  def valid_answer?(first_item)
    result ||= "はずれ！" unless first_item
    result ||= "同じ言葉は使えません！" if history.include? first_item

    engine = ShiritoriEngine.new
    if first_item and not engine.valid?(last_item.kana, first_item.kana)
      result ||= engine.errors.join(", ")
    end

    unless result.nil?
      @status = result
      false
    else
      true
    end
  end

  def last_item
    Item.find(@history.last)
  end
end
