class PasswordsController < ApplicationController
  def forgot
    render json: { error: 'Aucune adresse mail fournie' } if params[:email].blank?
    @user = User.find_by(email: params[:email])

    if @user.present?
      @user.generate_password_token # generate a pass token.
      UserMailer.reset_password(@user).deliver_now
      print(@user.email)
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: ["L'adresse mail n'a pas été trouvée. Veuillez vérifier et ré-éssayé"] }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s
    render json: { error: 'Aucune adresse mail fournie' } if params[:email].blank?
    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      user.reset_password!(params[:password]) ? success_response : error_response
    else
      render json: { error: ['Lien non valid ou expiré, veuillez générer un nouveau lien.'] }, status: :not_found
    end
  end

  private

  def success_response
    render json: { status: 'Le mot de passe a été changé avec succès.' }, status: :ok
  end

  def error_response
    render json: { error: user.error.full_messages }, status: :unprocessable_entity
  end
end
