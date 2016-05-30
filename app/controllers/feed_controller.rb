class FeedController < ApplicationController

	get '/' do
  	erb :newsfeed
	end

  get '/graphdata' do
    start_time = Time.parse(params[:startTime])
    end_time = Time.parse(params[:endTime])
    puts start_time
    puts end_time
    graph_type = params[:graph_type]

    enterprise = get_enterprise
    data = []
    args = {
      enterprise_id: enterprise.id,
      ts: start_time..end_time
    }
    case graph_type
    when 'ctr'
      (start_time.to_i..end_time.to_i).step(1.day) do |x|
        Data = Octo::Ctr.data( enterprise[:id], x)
        jsonData = {
          ts: Data[:ts],
          value: Data[:value]
        }
        data.push(jsonData)
      end
    when 'pageload'
      _args = args.merge({
        pageload_type: Octo::PageloadTime::NEWSFEED,
        counter_type: Octo::Counter::TYPE_DAY
      })
      res = Octo::PageloadTime.fakedata(_args)
      data = res.collect { |x| { ts: x.ts, value: x.time } }
    when 'engagement'
      _args = args.merge({
        engagement_type: Octo::EngagementTime::NEWSFEED,
        counter_type: Octo::Counter::TYPE_DAY,
      })
      res = Octo::EngagementTime.fakedata(_args)
      data = res.collect { |x| { ts: x.ts, value: x.time } }
    when 'absolute'
      _args = args.merge({
        type: Octo::Counter::TYPE_DAY
      })
      puts _args
      res = Octo::NewsfeedHit.fakedata(_args)
      data = res.collect { |x| { ts: x.ts, value: x.count }}
    end
    { data: data }.to_json
  end

end

