# gestionnaire de mail
class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: 'Veuillez trouver votre code temporaire de réinitialisation de mot de passe.')
  end
end
