class SegmentationController < ApplicationController
	
	get '/' do
  		erb :segmentation
	end

  get '/new' do
    erb :add_segmentation
  end

end