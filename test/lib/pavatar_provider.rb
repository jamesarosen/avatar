require 'rubygems'
gem 'rack', '0.9.1'
require 'sinatra'

get '/' do
  response['X-Pavatar'] = 'http://blog.example.com/pavatar.png'
end

get '/pavatar.png' do
  attachement('pavatar.png')
end
