require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/form_helpers'
require 'sinatra/reloader' if development?
require 'rack-flash'
require_relative 'app/models.rb'
require_relative 'app/controllers.rb'
require_relative 'app/helpers.rb'

set :erb, layout: :layout
enable :sessions
use Rack::Flash
