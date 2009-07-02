class ForumsController < ApplicationController

  def index
    @forums = Forum.find(:all)
  end

  def create
    # TODO adhoc
    passwd = params[:forum][:passwd]
    if passwd and passwd == 'laf'
      Forum.create(:title => params[:forum][:title],
                   :description => params[:forum][:description])
    else
      flash[:notice] = '認証できません。'
    end

    redirect_to :action => :index
  end

end
