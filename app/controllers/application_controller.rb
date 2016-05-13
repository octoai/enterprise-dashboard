# application_controller.rb
class ApplicationController < Sinatra::Base
  helpers ApplicationHelper, Sinatra::ContentFor

  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)
  set :public, File.expand_path('../../public', __FILE__)

end