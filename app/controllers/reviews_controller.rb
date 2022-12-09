class ReviewsController < ApplicationController
  before_action :set_movie
  before_action :require_signin

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
    @review.user = current_user

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

  # def set_movie
  #   @movie = Movie.find_by!(slug: params[:id])
  # end

  def notices
    {
      create: 'Review successfully created!',
      update: 'Review successfully updated!',
      delete: 'Review successfully deleted!'
    }
  end

  def review_params
    params.require(:review)
          .permit(:stars, :comment)
  end
end
