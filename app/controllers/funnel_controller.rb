class FunnelController < ApplicationController
	
	get '/' do
		erb :funnel
	end

  get '/new' do
    erb :add_funnel
  end

  post '/create' do
    name = params[:funnelName]
    data = params[:pages]
    "Successfully created funnel"
  end

  get '/pageNames' do
    
  end

end