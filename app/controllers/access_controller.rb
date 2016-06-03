class AccessController < ApplicationController
  # Display Login Form
  get '/login' do
    erb :login_form, :layout => :login_layout
  end

  # Perform Login
  post '/login' do
    username = params['username']
    password = params['password']
    res = fetch_consumer(username)
    if validate_password( username, password)
      session[:identity] = username
      session[:consumer_id] = res.enterprise_id
      session[:token] = save_session(username)
      redirect '/home'
    else
      redirect '/access/login'
    end
  end

  # Perform Logout
  get '/logout' do
    destroy_session(session[:identity])
    session.delete(:identity)
    session.delete(:token)
    redirect '/access/login'
  end

end