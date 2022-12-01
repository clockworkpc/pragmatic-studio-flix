class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      notice = "Thanks for signing up, #{@user.name}"
      redirect_to @user, notice:
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      notice = 'Account details updated.'
      redirect_to @user, notice:
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
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
end
