require 'time'

class FeedController < ApplicationController

	get '/' do
  	erb :feed
	end

  get '/conversion' do
    erb :feed_conversion
  end

  get '/conversion/data' do
    start_time = Time.parse(params[:startTime])
    end_time = Time.parse(params[:endTime])

    enterprise = get_enterprise
    json_arr = []

    (start_time.to_i..end_time.to_i).step(86400) do |x|
      ConversionData = Octo::Conversions.data( enterprise[:id], Octo::Conversions::NEWSFEED, x)
      jsonData = { 
        ts: ConversionData[:ts],
        value: ConversionData[:value]
      }
      json_arr.push(jsonData)
    end
    { data: json_arr}.to_json
  end

end