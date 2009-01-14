module GameHelper
  def iknow_link(item)
    link_to item.display_name, "http://www.iknow.co.jp/item/#{item.iknow_id}",
            :class => 'iknow_link', :target => "_blank"
  end
end
