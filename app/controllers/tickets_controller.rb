class TicketsController < ApplicationController

  def create
    @ticket = Ticket.new(ticket_params)
    @event = Event.find(update_params)
    if @ticket.save
      # Mise à jour de photo_url avec l'URL Cloudinary
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

  def update
    @ticket = Ticket.find(params[:id])
    print(update_params)
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
    params.permit(:type, :description, :price, :verified, :user_id, :event_id, :qr_code_url, :id)
  end

  def update_params
    params.permit(:user_id, :id)
  end

  def generate_qr_code_and_attach_to_ticket(ticket)
    # Logique pour générer le QR code (utilisez rqrcode ou une autre bibliothèque)
    qrcode = RQRCode::QRCode.new("#{ticket.id},#{ticket.event_id},#{ticket.type}")
    png = qrcode.as_png(size: 120)

    # Enregistrez l'image temporaire
    temp_file = Tempfile.new(['qr_code', '.png'])
    temp_file.binmode
    temp_file.write(png.to_s)
    temp_file.rewind

    # Attachez le fichier à l'instance du Ticket
    ticket.photo.attach(io: temp_file, filename: 'qr_code.png')

    temp_file.close
    temp_file.unlink
  end

end
