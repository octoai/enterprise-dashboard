class EventController < ApplicationController

  get '/track' do
    erb :event_track
  end

  get '/uuid_data' do
    # service_type = params['service_type']
    uuid_value = params['uuid_value']
    response = nil
    
    begin
      res = Octo::ApiTrack.where(customid: uuid_value).first
      response = res[:json_dump]
      response.to_json
    rescue Exception => e
      "Wrong UUID Value"
    end
    
  end

end