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
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :date, :location, :category, :free)
  end
end
