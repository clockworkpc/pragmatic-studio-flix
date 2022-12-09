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

  def approved_movie_scopes
    %i[released upcoming recent hits flops]
  end

  def approved_movie_scope?(sym)
    approved_movie_scopes.include?(sym)
  end

  def set_movie
    key = params[:movie_id] || params[:id]
    @movie = Movie.find_by!(slug: key)
  end

  helper_method :current_user
  helper_method :current_user?
  helper_method :current_user_admin?
  helper_method :approved_movie_scopes
  helper_method :approved_movie_scope?
end
