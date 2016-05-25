class FeedController < ApplicationController

	get '/' do
  	erb :newsfeed
	end

  get '/graphdata' do
    start_time = Time.parse(params[:startTime])
    end_time = Time.parse(params[:endTime])
    graph_type = params[:graph_type]

    enterprise = get_enterprise
    json_arr = []
    if graph_type == 'ctr'
      (start_time.to_i..end_time.to_i).step(86400) do |x|
        Data = Octo::Ctr.data( enterprise[:id], x)
        jsonData = { 
          ts: Data[:ts],
          value: Data[:value]
        }
        json_arr.push(jsonData)
      end
    else
      (start_time.to_i..end_time.to_i).step(86400) do |x|
        ConversionData = Octo::Conversions.data( enterprise[:id], Octo::Conversions::NEWSFEED, x)
        jsonData = { 
          ts: ConversionData[:ts],
          value: ConversionData[:value]
        }
        json_arr.push(jsonData)
      end
    end
    {data: json_arr}.to_json
  end

end