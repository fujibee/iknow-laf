class ForumsController < ApplicationController

  def index
    @forums = Forum.find(:all)
  end

end
