# example_controller.rb
class HomeController < ApplicationController

	get '/' do
    smart_segments = get_enterprise.segments.select { |x| x.intelligence }
    @seg_data = []
    smart_segments.each do |x|
      i = x.data(Time.now)
      @seg_data << { title: x.name.split(' ')[0], value: i.value[1] }
    end

    @today = {
      'Most Engaged Users' => {
        :title => 'Down by 0.1%',
        :wow => 0.6,
        :oye => -0.1
      },
      'Notifications Sent' => {
        :title => 'Unchanged',
        :wow => 0.5,
        :oye => 0.0
      },
      'Feed Engagement' => {
        :title => 'Up by 8%',
        :wow => 4.5,
        :oye => 8
      }
    }
  	erb :home
	end

end
