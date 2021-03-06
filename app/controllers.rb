before do
  params.delete(:captures)
end

before '/new' do
  logged_in_user?
end

after do
  session[:previous_path] = request.url
end

['/artigos/:route', '/artigos/:route/edit'].each do |path|
  before path do
    @post = Post.find_by(route: params['route'])
  end
end

['/', '/new', '/search', '/artigos/:route'].each do |path|
  before path do
    @posts = Post.all
  end
end

get '/' do
  @lastpost = Post.last
  @title = @lastpost.title
  erb :main
end

get '/artigos/:route' do
  @title = @post.title
  @comments = @post.comments
  @previous_request = session[:previous_path]
  @post_comment_request = session[:post_comment_path]
  erb :show
end

get '/new' do
  @user = User.find_by(id: session[:id])
  @previous_request = session[:previous_path]
  @control_panel_request = [session[:delete_post_path], session[:save_image_path], session[:delete_image_path]]
  get_images
  erb :new
end

post '/posts' do
  @post = Post.create(params[:post])
  @post.route = route_maker(@post.title)
  if @post.save
    redirect '/new'
  end
end

post '/comments' do
  @comment = Comment.create(params[:comment])
  @comment.body.gsub!(/\n+/, '<br>')
  session[:post_comment_path] = request.url
  if !@comment.save
    flash[:error] = "Nome e/ou email inválidos"
  end
  redirect "/artigos/#{@comment.post.route}"

end

get '/artigos/:route/edit' do
  erb :edit
end

put '/artigos/:route' do
  @post.route = route_maker(@post.title)
  if @post.update(params[:post])
    redirect '/new'
  end
end

delete '/artigos/:id' do
  Post.destroy(params['id'])
  session[:delete_post_path] = request.url
  redirect '/new'
end

post '/search' do
  search = Search.new(params[:search][:input])
  previous_path = session[:previous_path]
  redirect "#{previous_path}" if search.input == ""
  session[:input] = search.input.downcase
  redirect '/search'
end

get '/search' do
  @search_input = /#{session[:input]}/
  session.delete(:input)
  erb :search
end

get '/login' do
  erb :login
end

post '/login' do
  @user = User.find_by(name: params[:user][:name])
  if @user && @user.authenticate(params[:user][:password])
    session[:id] = @user.id
    redirect '/new'
  else
    flash[:error] = "Nome e/ou senha inválidos"
    redirect '/login'
  end
end

get '/logout' do
  session.delete(:id)
  redirect '/login'
end

post '/save_image' do
  if params[:file] != nil
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]

    File.open("./public/images/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
  end
  session[:save_image_path] = request.url
  redirect '/new'
end

delete '/images/:filename' do
  File.delete("./public/images/#{params['filename']}")
  session[:delete_image_path] = request.url
  redirect '/new'
end
