class SettingsController < ApplicationController

  get '/' do
    @apikey = get_api_key
    erb :settings
  end

end