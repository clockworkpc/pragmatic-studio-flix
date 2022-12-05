class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user_admin?
    current_user&.admin?
  end

  def require_admin
    return if current_user_admin?

    redirect_to root_url, alert: 'Unauthorized!'
  end

  def require_signin
    return if current_user

    session[:intended_url] = request.url
    alert = 'Please sign in'
    redirect_to new_session_url, alert:
  end

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user
  helper_method :current_user?
  helper_method :current_user_admin?
end
