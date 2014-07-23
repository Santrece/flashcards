enable :sessions

get '/' do
  erb :index
end

post '/signup' do
  if params[:password1] == params[:password2]
    @user = User.new(username: params[:username], password: params[:password1])
    if @user.save
      session[:user_id] = @user.id
      redirect to "/userpage/#{@user.username}"
    else
      @errors = @user.errors
    end
  else
    @errors = ["Your passwords did not match."]
    erb :index
  end
end

post '/signin' do
  @user = User.authenticate(params[:username], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect to "/userpage/#{@user.username}"
  else
    @errors = ["Incorrect login information."]
    erb :index
  end
end

get '/userpage/:username' do
  @user = User.find_by_username(params[:username])
  if @user && session[:user_id] == @user.id
    erb :user_homepage
  else
    @errors = ["You are not logged in."] # ?
    erb :index
  end
end

post '/logout' do
  session[:user_id] = nil
  @errors = ["You have logged out"]
  erb :index
end
# class User < ActiveRecord::Base
#   validates :username, uniqueness: {message: "This username is already taken."}
# end
