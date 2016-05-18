class SegmentationController < ApplicationController
	
	get '/' do
  	erb :segmentation
	end

  get '/new' do
    @operators = Octo::Segmentation::Helpers.operators_as_choice
    @dimensions = Octo::Segmentation::Helpers.dimensions_as_choice
    @logic_operators = Octo::Segmentation::Helpers.logic_operators_as_choice
    @events = []
    Octo::ApiEvent.all.select do |x|
      @events.push(x[:eventname])
    end
    erb :add_segmentation
  end

  get '/list' do
    # List of all segmentations
  end

  get '/list/operators' do
    # List of all operators
    Octo::Segmentation::Helpers.operators_as_choice
  end

  get '/list/dimensions' do
    # List of all dimensions
    Octo::Segmentation::Helpers.dimensions_as_choice
  end

  get '/list/logic_operators' do
    # List of all logic operators
    Octo::Segmentation::Helpers.logic_operators_as_choice
  end

  get '/create' do
    # Create a new Segmentation
  end

end