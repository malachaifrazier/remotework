class AlertsController < ApplicationController
  def index
  end

  def new
    @tags = (params[:tags] || '').split('+')
    @q = params[:q]
    @email_address = EmailAddress.new
    @alert = Alert.new(tags: @tags)
  end

  def create
    @email_address = EmailAddress.subscribe!(email_params[:email])
    @alert = Alert.create(alert_params.merge(email_address_id: @email_address.id))
    redirect_to email_address_path(@email_address.login_token)
  end

  def destroy
    @alert = Alert.find(params[:id])
    if @alert.delete
      flash[:notice] = 'Your alert has been deleted.'
    else
      flash[:notice] = "We had a problem deleting your alert: #{@alert.errors.full_messages.to_sentence}"
    end
    redirect_to email_address_path(@alert.email_address.login_token)
  end

  private

  def alert_params
    params.require(:alert).permit(:frequency, :search_query, :tags => [])
  end

  def email_params
    params.require(:email_address).permit(:email)
  end
end
