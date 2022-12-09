class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]

  def index
    @filter = set_movie_scope
    @movies = Movie.send(@filter)
  end

  def show
    @movie = Movie.find(params[:id])
    @fans = @movie.fans
    @favourite = current_user.favourites.find_by(movie_id: @movie.id) if current_user
    @genres = @movie.genres
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
                  :director, :duration, :image_file_name, genre_ids: [])
  end

  def notices
    {
      create: 'Movie successfully created!',
      update: 'Movie successfully updated!',
      delete: 'Movie successfully deleted!',
      unauthorized: 'Access to this page not authorized!'
    }
  end

  def set_movie_scope
    return :released if params[:filter].nil?

    filter = params[:filter].to_sym
    return :released unless approved_movie_scope?(filter)

    filter
  end
end
