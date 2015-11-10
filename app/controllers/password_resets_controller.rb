# -*- coding: utf-8 -*-
class PasswordResetsController < ApplicationController
  def new
    # View Password Reset Request
  end

  def create
    # Create Password Reset Request
    @user = User.find_by(email: params[:email])
    if user
      @user.regenerate_password_reset_token
      UserMailer.password_reset(@user.id).deliver_later(queue: 'high') if user.save
    end
    redirect_to jobs_path, notice: "Help is on the way! We've sent you password reset instructions."
  end

  def edit
    # View Change password
    @user = User.find_by(password_reset_token: params[:id])
    redirect_to(jobs_path, notice: "Password reset failed.") and return unless @user
  end

  def update
    # Change password
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to jobs_path, notice: 'Password reset.'
    else
      flash[:notice] = "Problem resetting password: #{@user.errors.full_messages.to_sentence}"
      render :edit
    end
  end

  private

  def user_params
    params.permit(:user).permit(:password, :password_confirmation)
  end
end
