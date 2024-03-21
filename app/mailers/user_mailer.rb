
class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: 'Find your reset temporary code')
  end
end
