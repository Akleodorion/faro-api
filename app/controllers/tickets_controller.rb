class TicketsController < ApplicationController
  def create
    @ticket = Ticket.new(ticket_params.except(:id))
    @event = Event.find(params[:event_id])
    if @ticket.save
      generate_qr_code_and_attach_to_ticket(@ticket)
      @ticket.update(qr_code_url: @ticket.photo.blob.url)
      render json: { ticket: @ticket }, status: :created
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @tickets = Ticket.where(user_id: params[:user_id])
    render json: @tickets
  end

  def transfer_ticket
    @ticket = Ticket.find(params[:id])
    is_my_ticket = params[:user_id] == @ticket.user_id
    if !is_my_ticket
      @ticket.update(transfer_ticket_params) ? update_success_response : update_error_response
    else
      render json: { errors: 'Vous ne pouvez pas vous envoyer un ticket' }, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    if @ticket.destroy
      render json: { message: 'Ticket supprimé avec succès' }
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ticket_params
    params.permit(:type, :description, :price, :verified, :user_id, :event_id, :qr_code_url, :id)
  end

  def transfer_ticket_params
    params.permit(:user_id, :id)
  end

  def update_success_response
    render json: { ticket: @ticket, message: 'Ticket modifié avec succès' }
  end

  def update_error_response
    render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
  end

  def generate_qr_code_and_attach_to_ticket(ticket)
    qrcode = RQRCode::QRCode.new("#{ticket.id},#{ticket.event_id},#{ticket.type}")
    png = qrcode.as_png(size: 120)

    temp_file = Tempfile.new(['qr_code', '.png'])
    temp_file.binmode
    temp_file.write(png.to_s)
    temp_file.rewind

    ticket.photo.attach(io: temp_file, filename: 'qr_code.png')

    temp_file.close
    temp_file.unlink
  end
end
