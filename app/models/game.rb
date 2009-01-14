class Game < ActiveRecord::Base

  attr_accessor :started, :history, :status, :failure_times

  def valid_answer?(first_item)
    error ||= "はずれ！" unless first_item
    error ||= "同じ言葉は使えません！" if first_item and @history.include? first_item.id

    @engine ||= ShiritoriEngine.new
    if first_item and not @engine.validate_connection(last_item.kana, first_item.kana)
      error ||= @engine.errors.first
    end

    @status = error
    error.nil?
  end

  def select_first_word_item(items)
    # new game is always valid.
    return items.first if @history.nil? or @history.empty?

    @engine ||= ShiritoriEngine.new
    items.each do |i|
      logger.debug "last:first #{last_item.kana}:#{i.kana}"
      return i if @engine.validate_connection(last_item.kana, i.kana)
    end
    nil
  end

  def last_item
    Item.find(@history.last) unless @history.nil?
  end
end
