class EmailAddressesController < ApplicationController
  def show
    @email_address = EmailAddress.find_by(login_token: params[:id])
  end
end
