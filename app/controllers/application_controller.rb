require 'cequel'
require 'octocore'

# application_controller.rb
class ApplicationController < Sinatra::Base

  helpers ApplicationHelper, Sinatra::ContentFor

  configure do
    enable :sessions
  end

  before do
    pass if %w[access login].include? request.path_info.split('/')[1]
    unless session[:identity] && validate_token(session[:identity], session[:token])
      session.delete(:identity)
      session.delete(:token)
      halt erb :login_form, :layout => :login_layout
    end
  end

  Octo.connect_with_config_file(File.join(Dir.pwd, 'config', 'config.yml'))

  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

end
