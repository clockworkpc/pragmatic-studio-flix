class Movie < ApplicationRecord
  has_many :reviews, -> { order(created_at: :desc) }, inverse_of: :movie, dependent: :destroy
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

  # def self.released
  #   where(released_on: ..Date.today).order('released_on desc')
  # end

  scope :released, -> { where(released_on: ..Time.zone.today).order('released_on desc') }
  scope :upcoming, -> { where(released_on: Time.zone.today..).order('released_on asc') }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { released.where(total_gross: 300_000_000..).order(total_gross: :desc) }
  scope :flops, -> { released.where(total_gross: ..250_000_000).order(total_gross: :asc) }
  scope :grossed_less_than, ->(n) { where(total_gross: ...n) }
  scope :grossed_more_than, ->(n) { where(total_gross: n..) }

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
