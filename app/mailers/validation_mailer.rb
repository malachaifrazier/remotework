class ValidationMailer < ApplicationMailer
  def validate_email(email_id)
    @email_address = EmailAddress.find(email_id)
    @token = @email_address.login_token
    mail(to: @email_address.email, subject: "Please Validate your Account" , from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end
end
