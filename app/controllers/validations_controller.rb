# -*- coding: utf-8 -*-
class ValidationsController < ApplicationController
  # The REST gods are angry. This is a GET request that changes the state
  # of the server, but because we're sending a link in an e-mail we really
  # don't have much choice. :(
  def show
    @user = User.find_by(validation_token: params[:id])
    redirect_to(jobs_path, notice: "We encountered a problem validating your email.") and return unless @user.present?
    @user.email_validated!
    sign_in(@user)
    redirect_to user_path(current_user), notice: "Thanks for validating your email!"
  end

  def create
    UserMailer.validate(current_user.id).deliver_later(queue: 'high')
    redirect_to user_path(current_user), notice: "Email validation message has been sent to #{current_user.email}"
  end
end
