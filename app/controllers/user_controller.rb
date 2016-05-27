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
        start_ts = @params.fetch('start_time', 7.days.ago)
        end_ts = @params.fetch('end_time', Time.now)
        @persona = Octo::UserPersona.fakedata(@user, start_ts..end_ts)
      else
        @success = false
      end
    end
    erb :user
  end


end

