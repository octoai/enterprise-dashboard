require 'octocore'

class UserController < ApplicationController

  get '/:userid?' do
    @enterprise = Octo::Enterprise.first
    user = Octo::User.find_by_enterprise_id_and_id(
      @enterprise.id,
      @params[:userid].to_i
    )
    if user
      @success = true
      @user = user
      @res = Octo::UserTimeline.fakedata(@user).collect do |x|
        x.human_readable
      end
    else
      @success = false
    end
    erb :user
  end

end

