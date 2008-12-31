class GameController < ApplicationController

  def index
    last_word = session[:last_word]
    last_word ||= "Apple"
    @last_word_item = Iknow::Item.matching(last_word).first if last_word
    first_word = params[:first_word]
    p first_word
    @first_word_item = Iknow::Item.matching(first_word).first if first_word
    if first_word
      session[:last_word] = first_word
      session[:history] = [] unless session[:history]
      session[:history] << @last_word_item
    end
  end

end
