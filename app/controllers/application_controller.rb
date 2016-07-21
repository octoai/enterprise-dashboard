require 'cequel'
require 'octocore'

# application_controller.rb
class ApplicationController < Sinatra::Base

  helpers ApplicationHelper, Sinatra::ContentFor

  configure do
    use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => 'ashdgjsf982u3e2jbd'
  end

  before do
    pass if %w[access login signup].include? request.path_info.split('/')[1]
    unless session[:identity] && validate_token(session[:identity], session[:token])
      session.delete(:identity)
      session.delete(:token)
      halt erb :login_form, :layout => :login_layout
    end
  end

  Octo.connect_with(File.join(Dir.pwd, 'config'))

  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)

end
