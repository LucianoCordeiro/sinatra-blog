helpers do

  def formatted_count(comments_count)
    if comments_count == 0
      "Nenhum comentário. Seja o primeiro a comentar!"
    elsif comments_count == 1
      "1 comentário"
    else
      "#{comments_count} comentários"
    end
  end

  def converter(title)
    title.force_encoding('UTF-8')
    return title if !title.include?('_') && !title.include?(' ')
    title.include?('_') ? title.gsub('_', ' ') : title.gsub(' ', '_')
  end

  def current_user
    @current_user ||= User.find_by(id: session[:id])
  end

  def logged_in?
    current_user != nil
  end

  def logged_in_user?
    if logged_in? == false
      redirect '/login'
    end
  end

  def html_tags_out(text)
    text.gsub!(/<[^>]+>/, '')
    text[0..200] + "..."
  end

  def get_images
    $images = Dir.entries("public/images").select {|d| d.size > 2 && d != "in.jpeg"}
  end

  def images_folder_size
    Dir.entries("public/images").length - 3
  end

end
