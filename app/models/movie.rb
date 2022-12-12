class Movie < ApplicationRecord
  before_save :set_slug

  has_many :reviews, -> { order(created_at: :desc) }, inverse_of: :movie, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterisations, dependent: :destroy
  has_many :genres, through: :characterisations
  has_one_attached :main_image

  RATINGS = %w[G PG PG-13 R NC-17].freeze
  validates :title, :released_on, :duration, presence: true
  validates :title, uniqueness: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validate :acceptable_image

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

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end

  def acceptable_image
    return unless main_image.attached?

    acceptable_size = main_image.blob.byte_size <= 1.megabyte
    acceptable_types = %w[image/jpeg image/png]
    acceptable_type = acceptable_types.include?(main_image.content_type)

    msg = {
      size: 'is too big',
      type: "must be one of the following: #{acceptable_types.join(', ')}"
    }

    errors.add(:main_image, msg[:size]) unless acceptable_size
    errors.add(:main_image, msg[:type]) unless acceptable_type
  end
end
