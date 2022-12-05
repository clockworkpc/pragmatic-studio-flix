class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email_or_username]) ||
           User.find_by(username: params[:email_or_username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to (session[:intended_url] || user),
                  notice: "Welcome back, #{user.name}"
    else
      flash.now[:alert] = 'Incorrect email/password combination'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    notice = 'User has been signed out.'
    redirect_to movies_path, status: :see_other, notice:
  end
end
