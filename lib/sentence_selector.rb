class SentenceSelector

  def select(iknow_id)
    item = Iknow::Item.find(iknow_id, :include_sentences => true)
    return unless item.sentences

    # too simple.. TODO improve algorithm
    cerego_items = []; has_picture = []; normal = []
    item.sentences.each do |sentence|
      if sentence.creator and sentence.creator.downcase == 'cerego'
        cerego_items << sentence
      elsif sentence.image
        has_picture << sentence
      else
        normal << sentence
      end
    end

    if cerego_items.size > 0
      cerego_and_picture = cerego_items.select {|i| i.image }
      cerego_and_picture.first if cerego_and_picture
    elsif has_picture.size > 0
      has_picture.first
    else
      normal.first if normal.size > 0
    end
  end

end
