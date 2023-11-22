class TicketsController < ApplicationController

  def create
    @ticket = Ticket.new(ticket_params)
    @event = Event.find(params[:event_id])

    if maximum_ticket_reached(@ticket, @event)
      render json:  {message: "Il n'y a plus de ticket de ce type disponible"}
    else
      if @ticket.save
        render json: { ticket: @ticket }, status: :created
      else
        render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      end
    end

  end

  def index
    @tickets = Ticket.where(user_id: params[:user_id])
    render json: @tickets
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update(ticket_params)
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


  def maximum_ticket_reached(ticket, event)
    case ticket.type
    when "standard"
      tickets = event.tickets
      tickets = tickets.select {|ticket| ticket.type == "standard"}
      if (tickets.count >= event.max_standard_ticket)
        return true
      else
        return false
      end
    when "vip"
      tickets = event.tickets
      tickets = tickets.select {|ticket| ticket.type == "vip"}
      if (tickets.count >= event.max_vip_ticket)
        return true
      else
        return false
      end
    when "vvip"
      tickets = event.tickets
      tickets = tickets.select {|ticket| ticket.type == "vvip"}
      puts tickets
      if (tickets.count >= event.max_vvip_ticket)
        return true
      else
        return false
      end
    else

    end
  end
end
