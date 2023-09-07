class Event < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 50, maximum: 200 }
  validates :date, presence: true, date: { after_or_equal_to: Time.now }
  validates :location, presence: true # vérifier que la localisation existe bel est bien
  validates :category, inclusion: { in: %w[loisir concert voyage] }
end
