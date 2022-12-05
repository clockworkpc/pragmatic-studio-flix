class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]

  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to(@movie, notice: notices[:create])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to(@movie, notice: notices[:update])
    else
      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    @movie = Movie.find(params[:id])

    if @movie.destroy
      redirect_to movies_path, status: :see_other, notice: notices[:destroy]
    else
      alert = 'Movie NOT deleted, something went wrong.'
      render :edit, status: :unprocessable_entity, alert:

    end
  end

  private

  def movie_params
    params.require(:movie)
          .permit(:title, :rating, :description, :released_on, :total_gross,
                  :director, :duration, :image_file_name)
  end

  def notices
    {
      create: 'Movie successfully created!',
      update: 'Movie successfully updated!',
      delete: 'Movie successfully deleted!',
      unauthorized: 'Access to this page not authorized!'
    }
  end
end
