require 'cequel'
require 'octocore'

# application_controller.rb
class ApplicationController < Sinatra::Base
  helpers ApplicationHelper, Sinatra::ContentFor

  Octo.connect_with_config_file(File.join(Dir.pwd, 'config', 'config.yml'))

  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)
  set :public, File.expand_path('../../public', __FILE__)

end
