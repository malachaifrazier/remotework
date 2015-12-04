class UserMailer < ApplicationMailer
  layout "transactional_email"
  
  def password_reset(user_id)
    @user = User.find(user_id)
    @token = @user.password_reset_token
    mail(to: @user.email, subject: "Password Reset Instructions" , from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end

  def validate(user_id)
    @user = User.find(user_id)
    @token = @user.validation_token
    mail(to: @user.email, subject: "Welcome aboard! Please validate your account." , from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end
end
