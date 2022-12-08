class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterisations, dependent: :destroy
  has_many :genres, through: :characterisations

  RATINGS = %w[G PG PG-13 R NC-17].freeze
  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: 'must be a JPG or PNG image'
  }
  validates :rating, inclusion: { in: RATINGS }

  def self.released
    where(released_on: ..Date.today).order('released_on desc')
  end

  def flop?
    cult_classic = reviews.count > 50 && reviews.average(:stars) > 4
    return false if cult_classic

    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars
    return 0.0 if reviews.count.zero?

    reviews.average(:stars)
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100
  end
end
