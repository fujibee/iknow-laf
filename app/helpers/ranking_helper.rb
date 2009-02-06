module RankingHelper

  def display_game_end_at(game)
    game.created_at.localtime.strftime("%m/%d %H:%M")
  end

  def display_order_type(order)
    if order == 'score'; 'ベストスコア'
    elsif order == 'created_at'; '最近のしりとり'
    end
  end

  def link_to_letter(letter, label = nil)
    return label unless letter
    label ||= letter
    link_to_remote(label, :update => 'letter',
                   :url => {:action => :change_letter},
                   :with => "'letter=' + encodeURIComponent('#{letter}')")
  end
end
