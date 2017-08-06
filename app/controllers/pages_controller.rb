class PagesController < ApplicationController
  def callback
    id = request.env['omniauth.auth']['uid']
    user_token = request.env['omniauth.auth']['credentials']['token']
    user_secret = request.env['omniauth.auth']['credentials']['secret']
    @user = User.find_by_id(id)
    if !@user #run free version first time
      @user = User.create(:id => id,
                          :user_token=> user_token,
                          :user_secret => user_secret,
                          :app_token => ENV['consumer_key'],
                          :app_secret => ENV['consumer_secret'],
                          :kind =>User::FREE)

    end
    session[:user_id] = id
    redirect_to "/thankyou"
  end

  def signup

  end

  def will_pay
    session[:stripe_token] = params[:stripeToken]
    redirect_to "/auth/twitter"
  end


  def thankyou
    @user = User.find_by_id(session[:user_id])
  end
  def stats
  end

end
