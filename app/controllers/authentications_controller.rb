class AuthenticationsController < ApplicationController
  def callback
    omniauth = request.env['omniauth.auth']
    @user = User.create_omniauth omniauth
    sign_in(:user_info, @user)
    redirect_to root_url
  end
end
