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
    @job = Job::RemotelyAwesome.new
    @job.user = current_user || User.new
  end

  def create    
    @job = Job::RemotelyAwesome.new(job_params)
    render :new and return unless handle_user(user_params)
    @job.user = @user
    if @job.save
      redirect_to user_path(@user), notice: 'Job successfully created.'
    else
      flash[:error] = "Unable to create job post: #{@job.errors.full_messages.to_sentence}"
      render :new
    end
  end


  private


  def handle_user(user_params)
    if logged_in?
      @user = current_user
      return true 
    end
    if params[:account] == 'new'
      create_user(user_params)
    elsif params[:account] == 'existing'
      authenticate_user(user_params)
    end
  end

  def create_user(user_params)
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
    else
      flash[:errors] = "Invalid user information: #{@user.errors.full_messages.to_sentence}"       
      false
    end
  end

  def authentiate_user(user_params)
    @user = find_by(email: user_params[:email])
    if @user && @user.authenticate(user_params[:password])
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
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
