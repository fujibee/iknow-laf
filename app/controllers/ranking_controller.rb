class RankingController < ApplicationController

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
    @kana_key = params[:kana_key] || 'あ'
    @all_kana_keys = Item.all_kana_keys.map {|i| i.first_kana_key}.sort

    # TODO move to item model
    @items = Item.find_all_by_first_kana_key(@kana_key)
    @item_counts = {}
    @items.each do |item|
      count = GameItem.find_all_by_item_id(item.id).size
      @item_counts[item] = count if count > 0
    end
    @sorted_items = @item_counts.keys.sort do |a, b|
      @item_counts[b] <=> @item_counts[a]
    end
  end

  private

  def paginated_games(order)
    Game.paginate(:all, :order => "#{order} desc",
                  :page => params[:page], :per_page => 20)
  end

end
