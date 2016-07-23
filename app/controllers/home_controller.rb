# example_controller.rb
class HomeController < ApplicationController

	get '/' do
    if params['intro'] == 'true'
      @intro = true
    else
      @intro = false
    end
  	erb :home
	end

end
