# -*- coding: utf-8 -*-
class JobsController < ApplicationController
  def index
    @tags = (params[:tags] || '').split('+')
    @q = params[:q]
    query = Job.posted.for_tags(@tags).order('posted_at DESC')
    query = query.search(@q) if @q.present?
    @jobs = query.page(params[:page] || 1)
    respond_to do |format|
      format.html { render 'index', layout: 'listings' }
      format.js 
    end
  end

  def show
    @job = Job.friendly.find(params[:id])
  end

  def new
    defaults = current_user.defaults_from_previous_job if logged_in?
    @job = Job::RemotelyAwesome.new(defaults)
    @job.user = current_user || User.new
  end

  def edit
    @job = Job.friendly.find(params[:id])
  end

  def create    
Rails.logger.debug ">>>> 1"
    @job = Job::RemotelyAwesome.new(job_params)
Rails.logger.debug ">>>> 2"
    render :new and return unless handle_user(user_params)
    @job.user = @user
    if @job.save
      redirect_to preview_job_path(@job)
    else
      flash[:error] = "Unable to create job post: #{@job.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def preview
    @job = Job.friendly.find(params[:id])
  end

  def post
    @job = Job.friendly.find(params[:id])
    flash[:notice] = @job.post! ? "Your job has been posted." : "One more thing - please check your inbox. We need to verify your e-mail address before posting your job."
    redirect_to user_path(current_user)
  end

  private


  def handle_user(user_params)
Rails.logger.debug ">>>> HANDLE USER"
    if logged_in?
Rails.logger.debug ">>> LOGGED IN"
      @user = current_user
      return true 
    end
Rails.logger.debug ">>>> ACCOUNT #{params[:account].inspect}"    
    if params[:account] == 'new'
      create_user(user_params)
    elsif params[:account] == 'existing'
      authenticate_user(user_params)
    end
  end

  def create_user(user_params)
Rails.logger.debug ">>>>> USER PARAMS ARE #{user_params.inspect}"
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
    else
      flash[:error] = "Invalid user information: #{@user.errors.full_messages.to_sentence}"       
      false
    end
  end

  def authenticate_user(user_params)
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      sign_in(@user)
    else
      flash[:error] = 'Bad email / password combination.'
      false
    end
  end

  def job_params
    params.require(:job_remotely_awesome).permit(:title, :description, :category, :how_to_apply, :company, :location, :company_url, :company_description, :tags => [])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation) unless logged_in?
  end
end
