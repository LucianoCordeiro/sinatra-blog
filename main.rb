require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/form_helpers'
require 'sinatra/reloader' if development?
require 'rack-flash'
require_relative 'models.rb'

set :database, {adapter: "sqlite3", database: "art_site.sqlite3"}
set :erb, layout: :'layout.html'
enable :sessions
use Rack::Flash

class Search
  attr_reader :input
  def initialize(input)
    @input = input
  end
end

before do
  params.delete(:captures)
end

before '/new' do
  logged_in_user?
end

after do
  session[:previous_path] = request.url
end

['/artigos/:title', '/artigos/:title/edit'].each do |path|
  before path do
    @title = converter(params['title'])
    @post = Post.find_by(title: @title)
  end
end

['/', '/new', '/search', '/artigos/:title'].each do |path|
  before path do
    @posts = Post.all
  end
end

get '/' do
  @title = 'Home Page'
  @lastpost = Post.last
  erb :'main.html'
end

get '/artigos/:title' do
  @comments = @post.comments
  @previous_request = session[:previous_path]
  @post_comment_request = session[:post_comment_path]
  erb :'show.html'
end

get '/new' do
  @user = User.find_by(id: session[:id])
  erb :'new.html'
end

post '/posts' do
  @post = Post.create(params[:post])
  if @post.save
    redirect '/new'
  end
end

post '/comments' do
  @comment = Comment.create(params[:comment])
  @comment.body.gsub!(/\n+/, '<br>')
  if @comment.save
    session[:post_comment_path] = request.url
    redirect "/artigos/#{converter(@comment.post.title)}"
  end
end

get '/artigos/:title/edit' do
  erb :'edit.html'
end

put '/artigos/:title' do
  if @post.update(params[:post])
    redirect '/new'
  end
  erb :'edit.html'
end

delete '/artigos/:id' do
  Post.destroy(params['id'])
  redirect '/new'
end

post '/search' do
  search = Search.new(params[:search][:input])
  previous_path = session[:previous_path]
  redirect "#{previous_path}" if search.input == ""
  session[:input] = search.input
  redirect '/search'
end

get '/search' do
  @search_input = /#{session[:input]}/
  session.delete(:input)
  erb :'search.html'
end

get '/login' do
  erb :'login.html'
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

  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/images/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  get_images
  redirect '/new'
end

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

  def html_tags_out(string)
    new_string = ""
    switch = true
    string.each_char do |char|
      if switch && char != "<" && char != ">"
        new_string << char
      elsif char == ">"
        switch = true
      elsif char == "<"
        switch = false
      end
    end
    new_string[0..200] + "..."
  end

  def get_images
    $images = Dir.entries("public/images").select {|d| d.size > 2}
  end

end
