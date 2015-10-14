class JobsController < ApplicationController
  def index
    @jobs = Job.all.order('posted_at desc').page(params[:page] || 1).per(30)
    render 'index', layout: 'listings'
  end

  def show
    @job = Job.friendly.find(params[:id])
  end
end
