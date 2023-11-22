class MembersController < ApplicationController

  def create
    @member = Member.new(members_params)
    if @member.save
      render json: { ticket: @ticket }, status: :created
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @members = Member.where(user_id: members_params[:user_id])
    render json: @members
  end

  def destroy
    @member = Member.find(params[:id])
    if @member.destroy
      render json:  {message: 'Member supprimé avec succès'}
    else
      puts @member.errors.full_messages
      render json: { erros: @member.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def members_params
    params.permit(:user_id, :event_id)
  end
end
