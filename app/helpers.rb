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

  SPECIAL_CHARACTERS = {' ' => '_', 'á' => 'a', 'é' => 'e',
  'ó' => 'o', 'í' => 'i', 'ú' => 'u', 'õ' => 'o', 'ã' => 'a',
  'â' => 'a', 'ê' => 'e', 'ô' => 'o', '?' => ''}

  def route_maker(title)
    route = title.downcase
    SPECIAL_CHARACTERS.each {|key,value| route.gsub!(key, value)}
    route
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

  def previous_post(post)
    return nil if @posts[0] == post
    return  @posts[@posts.index(post) - 1]
  end

  def next_post(post)
    next_post = @posts[@posts.index(post) + 1]
    return next_post if next_post != nil
    return nil
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
