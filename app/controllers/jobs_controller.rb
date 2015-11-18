# -*- coding: utf-8 -*-
class JobsController < ApplicationController
  def index
    @tags = (params[:tags] || '').split('+')
    @q = params[:q]
    query = Job.posted.for_tags(@tags).order('posted_at DESC')
    query = query.search(@q) if @q.present?

    @featured = query.featured
    @today = query.not_featured.today.page(params[:page] || 1)
    @jobs = query.not_featured.before_today.page(params[:page] || 1)

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
    @job = Job::RemotelyAwesome.new(job_params)
    render :new and return unless handle_user(user_params)
    @job.user = @user
    if @job.save
      redirect_to preview_job_path(@job)
    else
      flash[:error] = "Unable to create job post: #{@job.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def update
    @job = Job.where(user_id: current_user.id).friendly.find(params[:id])
    render :edit and return unless handle_user(user_params)
    if @job && @job.update_attributes(job_params)
      if @job.posted?
        redirect_to user_path(current_user), notice: 'Your job post has been updated.'
      else
        redirect_to preview_job_path(@job)
      end
    else
      flash[:error] = "Unable to update job post: #{@job.errors.full_messages.to_sentence}"
      render :edit
    end
  end

  def destroy
    @job = Job.where(user_id: current_user.id).friendly.find(params[:id])
    if @job && @job.destroy!
      flash[:notice] = "The job posting for '#{@job.title}' has been deleted."
    else
      flash[:error] = "There was an error deleting the job posting for '#{@job.title}': #{@job.errors.full_messages.to_sentence}"
    end
    redirect_to user_path(current_user)
  end

  def preview
    @job = Job.where(user_id: current_user.id).friendly.find(params[:id])
  end

  def post
    @job = Job.where(user_id: current_user.id).friendly.find(params[:id])
    if @job.user.email_validated?
      @job.post!
      flash[:notice] = "Your job has been posted."
    end
    redirect_to user_path(current_user)
  end

  def pause
    @job = Job.where(user_id: current_user.id).friendly.find(params[:id])
    @job.pause!
    redirect_to user_path(current_user)
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
