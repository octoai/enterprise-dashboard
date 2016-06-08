# example_controller.rb
class HomeController < ApplicationController

	get '/' do
    enterprise = get_enterprise

    smart_segments = enterprise.segments.select { |x| x.intelligence }
    @seg_data = []
    smart_segments.each do |x|
      i = x.data(Time.now)
      if i
        @seg_data << { title: x.name.split(' ')[0], value: i.value[1].round(2) }
      end
    end

    @conv_data = Octo::Conversions.types.values.collect do |type_val|
      Octo::Conversions.data(enterprise.id, type_val, 3.days.ago..Time.now)
    end.flatten.group_by do |x|
      x.ts
    end.inject([]) do |r,e|
      key = e[0]
      values = e[1]
      r << values.inject({}) do |rs, el|
        val = (el.type == 1) ? 'Notification' : 'Newsfeed'
        rs[val] = el.value.round(2)
        rs
      end.merge( ts: key )
      r
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
