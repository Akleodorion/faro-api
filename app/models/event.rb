class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 50, maximum: 200 }
  validates :date, presence: true
  validates :location, presence: true # vérifier que la localisation existe bel est bien
  validates :category, inclusion: { in: %w[loisir concert voyage] }
end
