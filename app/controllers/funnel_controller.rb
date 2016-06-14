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
    enterprise = get_enterprise
    Octo::Funnel.new(
      enterprise_id: enterprise[:id],
      name: name,
      funnel: data).save!
    "Successfully created funnel"
  end

  get '/pageNames' do
    dataArray = ["All Products", "All Pages"]
    @enterprise = Octo::Enterprise.first
    res = Octo::Product.where(enterprise_id: @enterprise.id)
    res.each { |x| dataArray << x[:routeurl] }
    res = Octo::Page.where(enterprise_id: @enterprise.id)
    res.each { |x| x[:routeurl] }
    {data: dataArray}.to_json
  end

  get '/all' do
    enterprise = get_enterprise
    funnel_list = Octo::Funnel.find_all_by_enterprise_id(enterprise.id)
    {data: funnel_list}.to_json
  end

  get '/graph_data' do
    day_value = 1*24*60*60

    funnelName = params[:funnelName]
    start_time = params[:startTime] == '' ? (Time.now - (10*day_value)) : (Time.parse(params[:startTime]))
    end_time = params[:endTime] == '' ? (Time.now) : (Time.parse(params[:endTime]))

    enterprise = get_enterprise

    funnel = Octo::Funnel.where(enterprise_id: enterprise[:id], name_slug: funnelName).first
    data = funnel.data(start_time)
    counter = 0
    json_array = []
    funnel[:funnel].each do |x, index|
      json_array.push({title: x, value: data[:value][counter]})
      counter += 1
    end
    json_array.to_json
  end

end

