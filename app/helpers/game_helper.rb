module GameHelper

  def iknow_link(item)
    link_to item.display_name, "http://www.iknow.co.jp/item/#{item.iknow_id}",
            :class => 'iknow_link', :target => "_blank"
  end

  def loading_script
    "$(first_item_panel).innerHTML = '" + image_tag('loading.gif') + "';" +
    "$(last_item_panel).innerHTML = '" + image_tag('loading.gif') + "';" +
    "document.body.style.cursor = 'wait';"
  end

end
