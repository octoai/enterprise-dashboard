class SegmentationController < ApplicationController

	get '/' do
  	erb :segmentation
	end

  get '/new' do
    @enterprise = get_enterprise
    @operators = Octo::Segmentation::Helpers.operators_as_choice
    @dimensions = Octo::Segmentation::Helpers.dimensions_as_choice
    @logic_operators = Octo::Segmentation::Helpers.logic_operators_as_choice

    @events = []
    res = Octo::ApiEvent.find_all_by_enterprise_id(@enterprise.id)
    @events = res.collect { |x| x[:eventname] }
    erb :add_segmentation
  end

  get '/all' do
    # List of all segmentations
    enterprise = get_enterprise
    segment_list = Octo::Segment.find_all_by_enterprise_id(enterprise.id)
    {data: segment_list}.to_json
  end

  get '/list/operators' do
    # List of all operators
    Octo::Segmentation::Helpers.operators_as_choice
  end

  get '/list/dimensions' do
    # List of all dimensions
    Octo::Segmentation::Helpers.dimensions_as_choice
  end

  get '/dimensions' do
    dimension_id = params[:dimension].to_i
    enterprise = get_enterprise
    value_array = Octo::Segmentation::Helpers.choices_for_dimensions(dimension_id, enterprise[:id])
    {data: value_array}.to_json
  end

  get '/list/logic_operators' do
    # List of all logic operators
    Octo::Segmentation::Helpers.logic_operators_as_choice
  end

  post '/create' do
    # Create a new Segmentation
    @enterprise = get_enterprise
    jsonData = params[:jsonData].deep_symbolize_keys!
    event_type = nil
    args = {
      enterprise_id: @enterprise.id,
      name: jsonData[:name],
      type: 0,
      event_type: event_type,
      dimensions: jsonData[:dimensions].map(&:to_i),
      operators: jsonData[:operators].map(&:to_i),
      dim_operators: jsonData[:logicOperators].map(&:to_i),
      values: jsonData[:values]
    }
    Octo::Segment.new(args).save!
    "success"
  end

  get '/graph_data' do
    segmentName = params[:segmentName]
    enterprise = get_enterprise
    json_array = []
    day_value = 1*24*60*60
    
    Segment = Octo::Segment.where(enterprise_id: enterprise[:id], name_slug: segmentName).first

    10.times do |n|
      SegmentData = Segment.data(Time.now - n*day_value)
      jsonData = { 
        ts: SegmentData.ts,
        abs: SegmentData.value[0],
        perc: SegmentData.value[1]
      }
      json_array.push(jsonData)
    end
    
    json_array.to_json
  end

end
