class ItemsController < ApplicationController

  def index
    @items = Item.find(:all)
  end

  def delete_all
    Item.destroy_all
    redirect_to :action => :index
  end

end
