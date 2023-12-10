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
    render json: @events,include: ['members', 'tickets' ]
  end

  def show
    @event = Event.find(params[:id])
    render json: @event,include: ['members' ]
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      @event.update(photo_url: @event.photo.blob.url)
      render json: { event: @event , message: 'Événement modifié avec succès' }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_activation
    @event = Event.find(params[:id])

    if (@event.activated)
      render json: { errors: "l'évènement est déjà activé"}, status: :unprocessable_entity
    else
      if @event.update(activated: params[:activated])
        render json: { event: @event , message: 'Événement activé avec succès' }
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    end

  end

  def update_close
    @event = Event.find(params[:id])

    if (@event.closed)
      render json: { errors: "l'évènement est déjà fermé"}, status: :unprocessable_entity
    else
      if @event.update(closed:  params[:closed])
        render json: { event: @event , message: 'Événement fermé avec succès' }
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
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
      :name, :description, :date,:start_time, :end_time ,:country, :country_code, :locality,:sublocality, :road,:plus_code, :longitude, :latitude, :category, :free, :photo_url,
      :user_id, :id, :standard_ticket_price, :max_standard_ticket, :standard_ticket_description, :gold_ticket_price, :max_gold_ticket,
      :gold_ticket_description, :platinum_ticket_price, :max_platinum_ticket, :platinum_ticket_description, :photo, :activated, :closed
    )
  end


end
