# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    redirect_to(new_session_path, notice: "Bad email/password combination.") and return unless @user.present?
    if @user.authenticate(params[:password])
      sign_in(@user)
      redirect_to jobs_path, notice: 'Welcome back! You are now signed in.'
    else
      redirect_to new_session_path, notice: "Bad email/password combination."
    end
  end

  def destroy
    sign_out and redirect_to jobs_path, notice: 'You have been signed out.'
  end
end
