# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def iknow_item_link(item)
    link_to item.display_name, "http://www.iknow.co.jp/item/#{item.iknow_id}",
            :class => 'iknow_link', :target => "_blank"
  end

end
