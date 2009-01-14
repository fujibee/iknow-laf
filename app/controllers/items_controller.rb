class ItemsController < ApplicationController

  def index
    @items = Item.paginate(:page => params[:page], :per_page => 50)
  end

  def update
    item = Item.find(params[:id])
    item.update_attributes(:kana => params[:kana])
    render :nothing => true
  end

  def delete_all
    Item.destroy_all
    redirect_to :action => :index
  end

end
