class RuleController < ApplicationController
	
	get '/' do
    enterprise = get_enterprise

    # Fetch notification template categories
    rules = Octo::Rules.find_all_by_enterprise_id(enterprise.id)
    @rules_list = []
    rules.each do |x|
      temp = {:name => x[:name].to_s}
      @rules_list.push(temp)
    end

  	erb :rule
	end

  get '/new' do
    enterprise = get_enterprise
    
    # Fetch notification template categories
    templates = Octo::Template.find_all_by_enterprise_id(enterprise.id)
    @categories = []
    templates.each do |x|
      temp = {:category_type => x[:category_type].to_s}
      @categories.push(temp)
    end

    # Fetch segments
    segment_list = Octo::Segment.find_all_by_enterprise_id(enterprise.id)
    @segments = []
    segment_list.each do |x|
      temp = {:slugname => x[:name_slug], :name => x[:name]}
      @segments.push(temp)
    end

    erb :add_rule
  end

  post '/new' do

    rule_name = params[:name]
    segment_slug = params[:segment]
    templateCategory = params[:temp_cat]
    durationType = params[:duration]
    state = params[:state]
    daterange = params[:daterange].split(' - ')

    args = {}
    args[:enterprise_id] = get_enterprise.id
    args[:name_slug] = rule_name.to_slug

    if state == 'on'
      args[:active] = true
    else
      args[:active] = false
    end

    opt = {}
    opt[:name] = rule_name
    opt[:segment] = segment_slug
    opt[:template_cat] = templateCategory
    opt[:start_time] = Time.parse(daterange[0])
    opt[:end_time] = Time.parse(daterange[1])
    
    case durationType
    when 'daily'
      opt[:duration] = Octo::Rules::DAILY
    when 'weekly'
      opt[:duration] = Octo::Rules::WEEKLY
    when 'weekends'
      opt[:duration] = Octo::Rules::WEEKENDS
    when 'alternate'
      opt[:duration] = Octo::Rules::ALTERNATE
    end

    obj = Octo::Rules.findOrCreateOrUpdate(args, opt)
    puts obj.inspect

    redirect '/rule/'

  end

end