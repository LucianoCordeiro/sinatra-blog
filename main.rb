require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/form_helpers'
require 'sinatra/reloader' if development?

set :database, {adapter: "sqlite3", database: "art_site.sqlite3"}
set :erb, layout: :'layout.html'

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

before do
  params.delete(:captures) if params.key?(:captures) && params[:captures].empty?
end

get '/' do
  @title = 'Home Page'
  @posts = Post.all
  @lastpost = Post.last
  erb :'main.html'
end

get '/artigos/:title' do
  @post = Post.find_by(title: params['title'].gsub('_', ' '))
  @posts = Post.all
  @comments = @post.comments
  erb :'show.html'
end

get '/new' do
  @post = Post.new
  erb :'new.html'
end

post '/posts' do
  @post = Post.create(params[:post])
  if @post.save
    redirect '/'
  end
end

post '/comments' do
  @comment = Comment.create(params[:comment])
  if @comment.save
    redirect "/get/#{@comment.post.title.gsub(' ', '_')}"
  end
end
