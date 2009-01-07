class GameController < ApplicationController

  START_WORD = 'apple'
  def index
    @game = session[:game]
    if @game
      @last_word_item = @game.history.last

      first_word = params[:first_word]
      if first_word
        @first_word_item = Item.find_and_register(first_word)
        @game.history << @first_word_item
      end
    end
  end

  def new
    @last_word_item = Item.find_and_register(START_WORD)
    @game = Game.new(:started => true)
    @game.history = [@last_word_item]
    session[:game] = @game

    render :action => :index
  end

  def destroy
    session[:game] = nil
    render :action => :index
  end

end
