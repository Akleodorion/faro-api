class EventsController < ApplicationController
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      render json: @event, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @events = Event.all
    render json: @events
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      render json: { message: 'Événement modifié avec succès' }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find(params[:id])
    render json: @event
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      render json: { message: 'Événement supprimé avec succès' }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :date, :location, :category, :free)
  end
end
