class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :tickets, dependent: :destroy
  has_many :members, dependent: :destroy

  # Validation basique
  validates :name, presence: true, length: { minimum: 10, maximum: 50 }
  validates :description, presence: true, length: { minimum: 50, maximum: 600 }
  validates :latitude, :longitude, presence: true, numericality: { only_float: true }
  validates :date, :locality, :country, :country_code, :start_time, :end_time, presence: true
  validates :photo, presence: true, unless: :photo_attached?

  validates :category, inclusion: { in: %w[loisir concert sport culture] }

  # Validation ticket toujours active
  validates :standard_ticket_description, presence: true, length: { minimum: 20, maximum: 151 }
  validates :max_standard_ticket, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Validation ticket si payant
  validates :max_gold_ticket, :max_platinum_ticket, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: :not_free?
  validates :gold_ticket_price, :platinum_ticket_price,:standard_ticket_price , presence: true,numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: :not_free?
  validates :gold_ticket_description, :platinum_ticket_description, presence: true, length: { minimum: 20, maximum: 151 }, if: :not_free?
  validate :ticket_prices_order, if: :not_free?

  def photo_attached?
    photo.attached? || photo_url.present?
  end

  def ticket_prices_order
    return unless standard_ticket_price.present? && gold_ticket_price.present? && platinum_ticket_price.present?

    error_response if standard_ticket_price >= gold_ticket_price || gold_ticket_price >= platinum_ticket_price
  end

  def free?
    free
  end

  private

  def not_free?
    !free
  end

  def error_response
    errors.add(:base, "Les prix des tickets doivent être dans l'ordre croissant : standard < gold < platinum")
  end
end
