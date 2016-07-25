# example_controller.rb
class HomeController < ApplicationController

	get '/' do
    @intro = params['intro'] == 'true'
  	erb :home
	end

end
