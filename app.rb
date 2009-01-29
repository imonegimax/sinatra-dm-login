require 'rubygems'
require 'sinatra'
require 'config/database'

enable :sessions

def logged_in?
  return true if session[:user]
  nil
end

get '/' do
  if logged_in?
   "You are logged in! - <a href=\"/user/logout\">Logout</a>"
  else
    "You are not logged in! - <a href=\"/user/login\">Login</a>"
  end  
end

get '/user/login' do
     erb :login
end

post '/user/login' do
  if session[:user] = User.authenticate(params["login"], params["password"])
    redirect '/'
  else
    redirect '/fail'
  end
end

get '/user/logout' do
  session[:user] = nil
  redirect '/'
end

get '/fail' do
  "Login failed - <a href=\"/user/login\">Try again</a>"
end

