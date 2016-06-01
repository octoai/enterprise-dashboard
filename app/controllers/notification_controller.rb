include Octo::Stats

class NotificationController < ApplicationController

  get '/:overview_type/' do
    puts @params
    enterprise = Octo::Enterprise.first
    ts_begin = @params.has_key?('start_time') ? mktime_from_urlparam(@params['start_time']) : 7.days.ago
    ts_end = @params.has_key?('end_time') ? mktime_from_urlparam(@params['end_time']) : Time.now
    ts = ts_begin..ts_end
    args = {
     enterprise_id: enterprise.id,
     type: Octo::Counter::TYPE_DAY,
     ts: ts
    }
    res = Octo::NotificationHit.fakedata(args)

    # group the push notifications count on platforms first
    push_notifications = res.select do |x|
      Set.new([:android, :ios]).include?(x.uid.to_sym)
    end.group_by do |x|
      x.ts
    end.inject([]) do |r,e|
      key = e[0]
      values = e[1]
      r << values.inject({}) do |rs, el|
        rs[el.uid] = el.count
        rs
      end.merge( ts: key )
      r
    end

    # group the time groupings then
    time_groups = res.select do |x|
      Set.new(Octo::NotificationHit.time_slots).include?(x.uid)
    end.group_by do |x|
      x.ts
    end.inject([]) do |r,e|
      key = e[0]
      values = e[1]
      r << values.inject({}) do |rs, el|
        rs[el.uid] = el.count
        rs
      end.merge( ts: key )
      r
    end

    case @params[:overview_type]
    when 'platform'
      push_notifications.to_json
    when 'time'
      time_groups.to_json
    end
  end

	get '/template' do
    enterprise = get_enterprise
    @categories = []
    templates = Octo::Template.where(enterprise_id: enterprise[:id])
    templates.each do |x|
      temp = {:category_type => x[:category_type].to_s}
      @categories.push(temp)
    end
  	erb :notification_template
	end

  post '/template/update' do
    category = params['templateCategory']
    text = params['templateText']
    state = params['templateState']
    enterprise = get_enterprise
    args = {
      enterprise_id: enterprise[:id],
      category_type: category
    }
    options = {
      active: state,
      template_text: text
    }
    Octo::Template.findOrCreateOrUpdate(args, options)
    'success'
  end

  get '/template/data' do
    category = params['templateCategory']
    enterprise = get_enterprise
    args = {
      enterprise_id: enterprise[:id],
      category_type: category
    }
    result = Octo::Template.findOrCreate(args)

    text = result[:template_text]
    state = result[:active]
    {:text => text, :state => state}.to_json
  end

  get '/settings' do
    erb :notification_settings
  end

  post '/settings' do
    instrument(:upload_certificate) do
      upload_certificate(params['certificate'][:tempfile].read)
    end

    @response_string = 'Uploaded Successful'
    erb :notification_settings
  end


  get '/' do
    erb :notification
  end

end

