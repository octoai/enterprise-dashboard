# config.ru
require 'sinatra/base'
require 'sinatra/content_for'

# pull in the helpers and controllers
require './app/helpers/application_helper.rb'
require './app/controllers/application_controller.rb'

Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes
map('/access') {run AccessController}

map('/') {run HomeController}
map('/home') {run HomeController}
map('/feed') {run FeedController}
map('/funnel') {run FunnelController}
map('/notification') {run NotificationController}
map('/rule') {run RuleController}
map('/segmentation') {run SegmentationController}
map('/user') {run UserController}
map('/trends') { run TrendsController }
map('/event') { run EventController }
map('/conversion') {run ConversionController}
map('/settings') {run SettingsController}
map('/messages') {run MessagesController}
