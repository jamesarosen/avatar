require 'rubygems'
require 'sinatra'

get '/' do
  response['X-Pavatar'] = 'http://localhost:4567/pavatar.png'
end

get '/pavatar.png' do
  'yep' # we just need 200
end

get '/hsegment/pavatar.png' do
  'yep' # we just need 200
end
