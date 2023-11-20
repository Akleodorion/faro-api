class Event < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :name, presence: true, length: { minimum: 10 }
  validates :description, presence: true, length: { minimum: 50, maximum: 600 }
  validates :latitude, :longitude, presence: true, numericality: { only_float: true }
  validates :date, :location, presence: true
  validates :photo, presence: true, unless: :photo_attached?

  validates :category, inclusion: { in: %w[loisir concert sport culture] }

  # Validation ticket toujours active
  validates :standard_ticket_description, presence: true, length: { minimum: 20, maximum: 151 }
  validates :max_standard_ticket, presence: true, numericality: { only_integer: true }

  # Validation ticket si payant
  validates :max_vip_ticket, :max_vvip_ticket, presence: true, numericality: { only_integer: true }, if: :not_free?
  validates :vip_ticket_description, :vvip_ticket_description, presence: true, length: { minimum: 20, maximum: 151 }, if: :not_free?
  validate :ticket_prices_order, if: :not_free?


  def photo_attached?
    photo.attached? || photo_url.present?
  end

  def ticket_prices_order
    if standard_ticket_price.present? && vip_ticket_price.present? && vvip_ticket_price.present?
      if standard_ticket_price >= vip_ticket_price || vip_ticket_price >= vvip_ticket_price
        errors.add(:base, "Les prix des tickets doivent être dans l'ordre croissant : standard < VIP < VVIP")
      end
    end
  end



  private

  def not_free?
    !free
  end
end
