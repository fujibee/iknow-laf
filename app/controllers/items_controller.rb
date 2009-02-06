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
    logger.info ">> destroy.. #{item.id} #{item.display_name}"
    item.destroy
    redirect_to :action => :index
  end

  def destroy_all
    #Item.destroy_all
    session[:game] = nil
    redirect_to :action => :index
  end

end
