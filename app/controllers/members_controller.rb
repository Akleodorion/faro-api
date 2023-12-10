class MembersController < ApplicationController

  def create
    @user = User.find(members_params[:user_id])
    @member = Member.new(members_params)
    @member.username = @user.username
    if @member.save
      render json: { member: @member }, status: :created
    else
      render json: { errors: @member.errors.messages}, status: :unprocessable_entity
    end
  end

  def index
    @members = Member.where(user_id: members_params[:user_id])
    render json: @members
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy!
    render json: { message: 'Member supprimé avec succès' }
  rescue ActiveRecord::RecordNotDestroyed => e
    puts e.message
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end


  private

  def members_params
    params.permit(:user_id, :event_id)
  end
end
