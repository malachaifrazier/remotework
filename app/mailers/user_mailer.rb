class UserMailer < ApplicationMailer
  def password_reset(user_id)
    @user = User.find(user_id)
    @token = @user.password_reset_token
    mail(to: @user.email, subject: "Password Reset Instructions" , from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end
end
