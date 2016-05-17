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
    Octo::Funnel.new(
      enterprise_id: 'f4e85a12-1b44-11e6-a914-2bcd111c4f06',
      name: name,
      funnel: data).save!
    "Successfully created funnel"
  end

  get '/pageNames' do
    dataArray = ["All Products", "All Pages"]
    Octo::Page.all.select do |x|
      dataArray.push(x[:routeurl])
    end
    {data: dataArray}.to_json
  end

  get '/all' do
    funnels = []
    Octo::Funnel.all.select do |x|
      funnels.push(x.name_slug)
    end
    {data: funnels}.to_json
  end

  get '/graph_data' do
    funnelName = params[:funnelName]
    funnel = Octo::Funnel.where(enterprise_id: 'f4e85a12-1b44-11e6-a914-2bcd111c4f06', name_slug: funnelName).first
    data = Octo::FunnelData.where(enterprise_id: 'f4e85a12-1b44-11e6-a914-2bcd111c4f06', funnel_slug: funnelName).first
    counter = 0
    json_array = []
    funnel[:funnel].each do |x, index|
      json_array.push({title: x, value: data[:value][counter]})
      counter += 1
    end
    json_array.to_json
  end
end