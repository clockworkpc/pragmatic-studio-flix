class UsersController < ApplicationController
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update]
  before_action :set_user, only: %i[show destroy]
  before_action :require_admin, only: %i[destroy]

  def index
    @users = User.not_admins
  end

  def show
    @reviews = @user.reviews
    @favourite_movies = @user.favourite_movies
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      notice = "Thanks for signing up, #{@user.name}"
      redirect_to @user, notice:
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      notice = 'Account details updated.'
      redirect_to @user, notice:
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      alert = "Account for #{@user.name} has been deleted."
      redirect_to movies_path, status: :see_other, alert:
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :username, :password, :password_confirmation)
  end

  def require_correct_user
    set_user
    correct_user = current_user == @user || current_user.admin?
    redirect_to(root_url, status: :see_other) unless correct_user
  end

  def set_user
    @user = User.find_by!(username: params[:id])
  end
end
