class GameController < ApplicationController

  START_WORDS =
    ['apple', 'ant', 'bird', 'banana', 'cat', 'camel', 'duck', 'dog',
     'egg', 'elephant', 'flower', 'fish', 'gecko', 'guitar', 'horse', 'hat',
     'ice cream cone', 'iceberg', 'jellyfish', 'jacket', 'kite', 'key', 'ladybug',
     'mermaid', 'monster', 'notebook', 'necklace', 'octopus', 'orange', 'panda',
     'queen', 'quilt', 'rocket', 'rainbow', 'snake', 'star ', 'tomato',
     'toger', 'umbrella', 'violin', 'van', 'whale', 'watch', 'x-ray', 'xylophone',
     'yoyo', 'zebra']
  
  layout "application", :except => :iknow_panel

  def index
    # TODO ネストが深い・・
    @game = session[:game]
    if @game
      @last_word_item = Item.find(@game.history.last)

      first_word = params[:first_word]
      if first_word and not first_word.empty?
        @first_word_item = Item.find_and_register(first_word)
        if @game.valid_answer? @first_word_item
          @game.history << @first_word_item.id
        else
          @game.failure_times += 1
          @failure_item = @first_word_item || Item.new(:spell => first_word)
          if @game.failure_times >= 3
            flash[:failure_item] = @failure_item
            redirect_to :action => :destroy
          end
          flash[:notice] = @game.status
          @submit_label = "もう一度しりとり！"
        end
      else
        @failure_item = Item.new
        flash[:notice] = "何か入れてね！"
      end

      # TODO モデルへ
      engine = ShiritoriEngine.new
      letter = @first_word_item.nil? ? @last_word_item.kana.last : @first_word_item.kana.last
      @candidate_letter = engine.candidates(letter).join("、")
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

    render :action => :index
  end

  def destroy
    @game = session[:game]
    if @game
      @game.score = @game.history.size
      @game.save
      @failure_item = flash[:failure_item]
      session[:game] = nil
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
    logger.debug(item.to_yaml)
  end

end
