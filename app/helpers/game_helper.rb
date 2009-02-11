module GameHelper

  def shake_effect(page_element)
    page_element.visual_effect(:shake, :duration => 0.1, :distance => 10)
  end

  def highlight_effect(page_element)
    page_element.visual_effect(:highlight) 
  end
end
