class EventsController < ApplicationController
  def create
    @event = Event.new(event_params.except(:id))
    if @event.save
      # Mise à jour de photo_url avec l'URL Cloudinary
      @event.update(photo_url: @event.photo.blob.url)
      render json: { event: @event }, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @events = Event.all
    render json: @events
  end

  def show
    @event = Event.find(params[:id])
    render json: @event
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      render json: { event: @event , message: 'Événement modifié avec succès' }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      render json: { message: 'Événement supprimé avec succès' }
    else
      puts @event.errors.full_messages
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.permit(
      :name, :description, :date, :location, :longitude, :latitude, :category, :free, :photo_url,
      :user_id, :id, :standard_ticket_price, :max_standard_ticket, :standard_ticket_description, :vip_ticket_price, :max_vip_ticket,
      :vip_ticket_description, :vvip_ticket_price, :max_vvip_ticket, :vvip_ticket_description, :photo, :activated
    )
  end


end
