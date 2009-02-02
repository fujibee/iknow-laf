class ItemsController < ApplicationController

  def index
    @items = Item.paginate(:order => "spell",
                           :page => params[:page], :per_page => 50)
  end

  def search
    spell = params[:spell]
    sql = "select * from items where spell like ? order by spell"
    @items = Item.paginate_by_sql([sql, "%#{spell}%"],
                                  :page => params[:page], :per_page => 50)
    render :action => :index
  end

  def update
    item = Item.find(params[:id])
    item.kana = params[:kana]
    item.first_kana_key = ShiritoriEngine.new.kana_key(item.kana)
    item.save
    render :nothing => true
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to :action => :index
  end

  def destroy_all
    #Item.destroy_all
    session[:game] = nil
    redirect_to :action => :index
  end

  def ranking
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

end
