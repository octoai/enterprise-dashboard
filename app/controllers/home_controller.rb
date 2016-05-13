# example_controller.rb
class HomeController < ApplicationController
	
	get '/' do
  		erb :home
	end
	
end