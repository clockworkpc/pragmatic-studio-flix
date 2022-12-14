class FavouritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.favourites.create!(user: current_user)
    redirect_to @movie
  end

  def destroy
    favourite = current_user.favourites.find(params[:id])
    favourite.destroy

    redirect_to @movie
  end
end
