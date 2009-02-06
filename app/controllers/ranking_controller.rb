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

    # TODO move to item model
    items = Item.find_all_by_first_kana_key(@letter)
    @items_by_count = {}; counts = []
    items.each do |item|
      count = GameItem.find_all_by_item_id(item.id).size
      if count > 0
        @items_by_count[count] ||= []
        @items_by_count[count] << item
        counts << count
      end
    end
    @counts = counts.uniq.sort.reverse
  end

end
