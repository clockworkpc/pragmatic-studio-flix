class GenresController < ApplicationController
  before_action :require_signin
  before_action :require_admin
  before_action :set_genre, only: %i[edit show update destroy]

  def index
    @genres = Genre.all
  end

  def show
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_genre
    @genre = Genre.find_by!(slug: params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name, movie_ids: [])
  end
end
