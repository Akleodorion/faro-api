require 'rqrcode'
class Ticket < ApplicationRecord
  self.inheritance_column = :_non_existent_column
  belongs_to :user
  belongs_to :event
  has_one_attached :photo
  validates :type, presence: true, inclusion: { in: %w[standard gold platinum] }, on: :create
  validate :validate_max_tickets_reached, on: :create

  private

  def validate_max_tickets_reached
    case type
    when 'standard'
      validate_max_tickets(:max_standard_ticket)
    when 'gold'
      validate_max_tickets(:max_gold_ticket)
    when 'platinum'
      validate_max_tickets(:max_platinum_ticket)
    end
  end

  def validate_max_tickets(max_column)
    tickets = event.tickets.where(type:)

    # Check if the event is free and the user already has a ticket
    if event.free? && tickets.exists?(user:)
      errors.add(:base, 'You can only have one free ticket for this event')
      return
    end

    validate_max_tickets_error_response if tickets.count >= event.send(max_column)
  end

  def validate_max_tickets_error_response
    errors.add(:base, "Maximum number of #{type} tickets reached for this event")
  end
end
