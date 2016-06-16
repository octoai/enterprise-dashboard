require 'octocore'

class UserController < ApplicationController


  # specific to user
  get '/' do
    @enterprise = Octo::Enterprise.first
    @success = false

    if @params.has_key?('userid')
      user = Octo::User.find_by_enterprise_id_and_id(
        @enterprise.id,
        @params['userid'].to_i
      )
      if user
        @success = true
        @user = user
        @res = Octo::UserTimeline.fakedata(@user).collect do |x|
          x.human_readable
        end
        @start_ts = 7.days.ago
        if @params.has_key?('start_time') and @params['start_time'] != ''
          @start_ts = mktime_from_urlparam(@params['start_time'])
        end
        @end_ts = Time.now
        if @params.has_key?('end_time') and @params['end_time'] != ''
          @end_ts = mktime_from_urlparam(@params['end_time'])
        end
        @persona = Octo::UserPersona.fakedata(@user, @start_ts..@end_ts)
      else
        @success = false
      end
    end
    erb :user
  end


  get '/:userid?' do
    @enterprise = Octo::Enterprise.first
    user = Octo::User.find_by_enterprise_id_and_id(
      @enterprise.id,
      @params[:userid].to_i
    )
    if user
      @success = true
      @user = user
      @res = Octo::UserTimeline.fakedata(@user)
    else
      @success = false
    end
    erb :user
  end
end
