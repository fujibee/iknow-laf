class RankingController < ApplicationController

  layout "application", :except => :change_letter

  def index
    redirect_to :action => :game
  end

  def game
    @order = 'score'
    @games = paginated_games(@order)
  end

  def recent
    @order = 'created_at'
    @games = paginated_games(@order)
    render :action => :game
  end

  def item
    letter
  end

  def change_letter # for ajax
    letter
    render :partial => 'letter'
  end

  private

  def paginated_games(order)
    Game.paginate(:all, :order => "#{order} desc",
                  :page => params[:page], :per_page => 20)
  end

  def letter
    @all_kana_keys = Item.all_kana_keys.map {|i| i.first_kana_key}.sort
    @letter = params[:letter] || 'あ'
    index = @all_kana_keys.index(@letter) 
    @prev_letter = @all_kana_keys[index - 1] unless index == 0
    @next_letter = @all_kana_keys[index + 1] unless index == @all_kana_keys.size - 1

    @items_per_count = Item.find_items_per_count(@letter)
    @counts = @items_per_count.keys.uniq.sort.reverse
  end

end
