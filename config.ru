# config.ru
require 'sinatra/base'
require 'sinatra/content_for'

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes
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