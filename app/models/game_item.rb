class GameItem < ActiveRecord::Base

  belongs_to :game
  belongs_to :item

end
