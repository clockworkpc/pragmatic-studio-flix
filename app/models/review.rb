class Review < ApplicationRecord
  STARS = (1..5).to_a.freeze
  belongs_to :movie
  belongs_to :user

  validates :comment, length: { minimum: 4 }
  validates :stars, numericality: {
    only_integer: true,
    greater_than_or_equal_to: STARS.min,
    less_than_or_equal_to: STARS.max
  }

  def stars_as_percent
    (stars / STARS.max.to_f) * 100.0
  end
end
