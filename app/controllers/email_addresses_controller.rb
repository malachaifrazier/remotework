class EmailAddressesController < ApplicationController
  def show
    @email_address = EmailAddress.find_by(login_token: params[:id])
  end

  def validate
    @email_address = EmailAddress.find_by(validation_token: params[:email_address_id])
    render_404 and return unless @email_address
    @email_address.validate!
    flash[:notice] = "Sweet! Your address has been validated."
    redirect_to email_address_path(@email_address.login_token)
  end

  def unsubscribe
    @email_address = EmailAddress.find_by(login_token: params[:token])
  end

  def destroy
    @email_address = EmailAddress.find_by(login_token: params[:id])
    @email_address.unsubscribe!
    flash[:notice] = "You've been unsubscribed. Sorry to see you go!"
    redirect_to root_path
  end
end
