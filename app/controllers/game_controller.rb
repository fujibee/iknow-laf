class GameController < ApplicationController

  START_WORD = 'apple'
  def index
    # TODO ネストが深い・・
    @game = session[:game]
    if @game
      @last_word_item = @game.history.last

      first_word = params[:first_word]
      if first_word and not first_word.empty?
        first_word_item = Item.find_and_register(first_word)
        if @game.valid_answer? first_word_item
          @game.history << first_word_item
        else
          @failure_item = first_word_item
          flash[:notice] = @game.status
          @submit_label = "もう一度！"
        end
      else
        flash[:notice] = "何か入れてね！"
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
    # TODO 終了処理：ランキングとか

    session[:game] = nil
    render :action => :index
  end

end
