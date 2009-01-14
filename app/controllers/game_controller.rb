class GameController < ApplicationController

  START_WORDS =
    ['apple', 'ant', 'bird', 'banana', 'cat', 'camel', 'duck', 'dog',
     'egg', 'elephant', 'flower', 'fish', 'gecko', 'guitar', 'horse', 'hat',
     'iceberg', 'jellyfish', 'jacket', 'kite', 'key', 'ladybug',
     'mermaid', 'monster', 'notebook', 'necklace', 'octopus', 'orange', 'panda',
     'queen', 'quilt', 'rocket', 'rainbow', 'snake', 'star ', 'tomato', 'toger',
     'umbrella', 'van', 'whale', 'watch', 'yoyo', 'zebra']
  
  layout "application", :except => :iknow_panel

  def index
    @game = session[:game]
    if @game
      @last_word_item = Item.find(@game.history.last)

      first_word = params[:first_word]
      if first_word and not first_word.empty?
        candidate_items = Item.find_and_register(first_word)
        @first_word_item = candidate_items.first
        if @game.valid_answer? @first_word_item
          @game.history << @first_word_item.id
          flash[:notice] = "正解！"
          candidate_letter = @first_word_item.kana.last
        else
          @game.failure_times += 1
          @first_word_item ||= Item.new(:spell => first_word)
          if @game.failure_times >= 3
            redirect_to :action => :destroy
          end
          flash[:notice] = @game.status
          @submit_label = "もう一度しりとり！"
          candidate_letter = @last_word_item.kana.last
        end
      else
        @failure_item = Item.new
        flash[:notice] = "何か入れてね！"
        candidate_letter = @last_word_item.kana.last
      end

      # TODO モデルへ
      @candidate_letters = ShiritoriEngine.new.candidates(candidate_letter).join("、")
    end
  end

  def new
    start_word = START_WORDS[rand * START_WORDS.size]
    @last_word_item = Item.find_and_register(start_word)
    @game = Game.new(:started => true, :failure_times => 0)
    @game.history = [@last_word_item.id]
    @game.name = params[:name]
    @game.name = "名無し" if @game.name.empty?
    session[:game] = @game

    redirect_to :action => :index
    #render :action => :index
  end

  def destroy
    @game = session[:game]
    if @game
      flash[:notice] = @game.status
      @first_word_item = Item.new(:spell => params[:first_word])
      session[:game] = nil
      @game.score = @game.history.size
      @game.save
    else
      redirect_to :action => :index
    end
  end

  def ranking
    @games = Game.find(:all, :order => "score desc")
  end
  
  def iknow_panel
    @iknow_id = params[:iknow_id]
    item = Iknow::Item.find(@iknow_id, :include_sentences => true)
    @sentence = item.sentences.first if item.sentences
    if @sentence
      @image_url = @sentence.square_image
      @en_text = @sentence.text
      @ja_text = @sentence.translations.first.text
    end
    #logger.debug(item.to_yaml)
  end

end
