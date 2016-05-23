class NotificationController < ApplicationController

  get '/' do
    erb :notification
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

end