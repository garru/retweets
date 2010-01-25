$LOAD_PATH.unshift File.dirname(__FILE__)
require 'rubygems'
require 'sinatra'
# require 

set :public, File.join(File.dirname(__FILE__), '..', '..', 'public')

get '/' do
  haml :index
end

get '/stylesheet.css' do
   content_type 'text/css', :charset => 'utf-8'
   sass :stylesheet
end