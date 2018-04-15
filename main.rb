require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/form_helpers'
require 'sinatra/reloader' if development?

set :database, {adapter: "sqlite3", database: "art_site.sqlite3"}
set :erb, layout: :'layout.html'

class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
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
  @title = converter(params['title'])
  @post = Post.find_by(title: @title)
  @posts = Post.all
  @comments = @post.comments
  erb :'show.html'
end

get '/new' do
  @posts = Post.all
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
  @comment.body.gsub!(/\n+/, '<br>')
  if @comment.save
    redirect "/artigos/#{converter(@comment.post.title)}"
  end
end

get '/artigos/:title/edit' do
  @title = converter(params['title'])
  @post = Post.find_by(title: @title)
  erb :'edit.html'
end

put '/artigos/:title' do
  @title = converter(params['title'])
  @post = Post.find_by(title: @title)
  if @post.update(params[:post])
    redirect "/new"
    json 'Cat has been updated'
  end
  erb :'edit.html'
end

delete '/artigos/:id' do
  Post.destroy(params['id'])
  redirect "/new"
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
    return title if !title.include?('_') && !title.include?(' ')
    title.include?('_') ? title.gsub('_', ' ') : title.gsub(' ', '_')
  end

end
