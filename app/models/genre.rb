class Genre < ApplicationRecord
  before_save :set_slug
  validates :name, presence: true, uniqueness: true

  has_many :characterisations, dependent: :destroy
  has_many :movies, through: :characterisations

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
