class TicketsController < ApplicationController

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      render json: { ticket: @ticket }, status: :created
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @tickets = Ticket.all
    render json: @tickets
  end

  private

  def ticket_params
    params.permit(:type, :description, :price, :verified, :user_id, :event_id)
  end
end
