class TicketsController < ApplicationController

  def create
    @ticket = Ticket.new(ticket_params)
    @event = Event.find(params[:event_id])
    if @ticket.save
      render json: { ticket: @ticket }, status: :created
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @tickets = Ticket.where(user_id: params[:user_id])
    render json: @tickets
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(update_params)
      render json: {ticket: @ticket , message: 'Ticket modifié avec succès'}
    else
      puts @ticket.errors.full_messages
      render json: { errors: @ticket.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    if @ticket.destroy
      render json:  {message: 'Ticket supprimé avec succès'}
    else
      puts @ticket.errors.full_messages
      render json: { erros: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def ticket_params
    params.permit(:type, :description, :price, :verified, :user_id, :event_id)
  end

  def update_params
    params.permit(:user_id)
  end



end
