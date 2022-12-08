class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :characterisations, dependent: :destroy
  has_many :movies, through: :characterisations
end
