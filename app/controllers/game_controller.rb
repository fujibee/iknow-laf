class GameController < ApplicationController

  layout "application", :except => :iknow_panel

  START_WORDS =
    ['apple', 'ant', 'bird', 'banana', 'cat', 'camel', 'duck', 'dog', 'egg',
     'elephant', 'flower', 'fish', 'gecko', 'guitar', 'horse', 'hat', 'iceberg',
     'jellyfish', 'jacket', 'kite', 'key', 'ladybug', 'mermaid', 'monster',
     'notebook', 'necklace', 'octopus', 'orange', 'panda', 'queen', 
     'rocket', 'rainbow', 'snake', 'star ', 'tomato', 'toger',
     'umbrella', 'van', 'whale', 'watch', 'zebra']

  def index
    @game = session[:game]
    if @game
      @last_word_item = Item.find(@game.history.last)

      # TODO too complex... it could be entiry able to be managed by a "game" object.
      first_word = params[:first_word]
      if first_word and not first_word.empty?
        candidate_items = Item.find_and_register(first_word)
        @first_word_item = @game.select_first_word_item(candidate_items)
        if @game.valid_answer? @first_word_item
          @game.history << @first_word_item.id
          flash[:notice] = "正解！"
          candidate_word = @first_word_item.kana
        else
          @game.failure_times += 1
          @first_word_item ||= Item.new(:spell => first_word)
          if @game.failure_times >= 3
            redirect_to :action => :destroy
          end
          flash[:notice] = @game.status
          @submit_label = "もう一度しりとり！"
          candidate_word = @last_word_item.kana
        end
      else
        flash[:notice] = "何か入れてね！"
        candidate_word = @last_word_item.kana
      end

      # TODO to model object
      @candidate_letters = ShiritoriEngine.new.candidates(candidate_word).join("、")
    end
  end

  def new
    start_word = START_WORDS[rand * START_WORDS.size]
    candidate_items = Item.find_and_register(start_word)

    @game = Game.new(:started => true, :failure_times => 0)
    @last_word_item = @game.select_first_word_item(candidate_items)
    @game.history = [@last_word_item.id]
    @game.name = params[:name]
    session[:name] = @game.name # for second try

    @game.name = "名無し" if @game.name.empty?
    session[:game] = @game

    redirect_to :action => :index
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

  def destroy_all
    Game.destroy_all
    redirect_to :action => :ranking
  end

  def ranking
    @games = Game.paginate(:all, :order => "score desc",
                           :page => params[:page], :per_page => 100)
  end
  
  def iknow_panel
    @iknow_id = params[:iknow_id]
    item = Iknow::Item.find(@iknow_id, :include_sentences => true)
    @sentence = item.sentences.first if item.sentences
    if @sentence
      @image_url = @sentence.square_image
      @en_text = @sentence.text
      @ja_text = @sentence.translations.first.text if @sentence.translations
    end
    #logger.debug(item.to_yaml)
  end

end
