# # when a form is submitted to the 'sign-in' url with a POST request
# post '/sign-in' do
#   # set @user equal to a user that has the username requested
#   # use .first after .where because .where always returns an array,
#   # this way you're working with a singular user object
#   @user = User.where(username: params[:username]).first
#   # first check if a user is returned at all (nil is a 'falsey' value)
#   # then check if the user's password is correct
#   if @user && @user.password == params[:password]
#     # log in the user by setting the session[:user_id] to their ID
#     session[:user_id] = @user.id
#     # set a flash notice letting the user know that they've logged in successfully
#     flash[:notice] = "You've been signed in successfully."
#   else
#     # if the user doesn't exist or their password is wrong, send them a 
#     # flash alert saying so
#     flash[:alert] = "There was a problem signing you in."
#   end
#   # redirect them to the home page
#   redirect "/"
# end

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'

configure(:development){set :database, "sqlite3:sign-in.sqlite3"}
enable :sessions

get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
  end

    erb :index
end

get '/sign-in' do
  erb :sign_in_form
end

post '/sign-in' do
  @user = User.where(email: params[:email]).first

  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "The Matrix has you..."
  else
    flash[:alert] = "Are you sure that's air you're breathing?"
  end

  redirect '/'
end

get '/sign-out' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    session[:user_id] = nil
    flash[:notice] = "You have been signed out of the Matrix..."
  else
    flash[:alert] = "You must first choose the Red Pill"
  end

  redirect '/'
end