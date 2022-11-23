class ReviewsController < ApplicationController
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    if @review.save
      redirect_to(movie_reviews_path(@movie), notice: notices[:create])
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @review = Review.find(params[:id])

    if @review.destroy
      redirect_to movie_reviews_path(@movie), status: :see_other, notice: notices[:delete]
    else
      alert = 'Review NOT deleted, something went wrong'
      render :new, status: :unprocessable_entity, alert:
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def notices
    {
      create: 'Review successfully created!',
      update: 'Review successfully updated!',
      delete: 'Review successfully deleted!'
    }
  end

  def review_params
    params.require(:review)
          .permit(:name, :stars, :comment)
  end
end
