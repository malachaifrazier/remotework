class JobsController < ApplicationController
  def index
    @jobs = Job.all.order('posted desc').page(params[:page] || 1).per(30)
  end

  def show
    @job = Job.friendly.find(params[:id])
  end
end
