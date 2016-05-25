class EventController < ApplicationController

  get '/track' do
    erb :event_track
  end

  get '/uuid_data' do
    uuid_value = params['uuid_value']
    response = nil
    
    begin
      res = Octo::ApiTrack.where(customid: uuid_value).first
      res[:json_dump]
    rescue Exception => e
      "Wrong UUID Value"
    end
  end

end