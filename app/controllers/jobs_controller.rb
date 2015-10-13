class JobsController < ApplicationController
  def index
    @jobs = Job.all.order('posted_at desc').page(params[:page] || 1).per(30)
    respond_to do |format|
      format.html { render partial: 'shared/jobs_list', locals: {jobs: @jobs} }
      format.js {}
    end
  end

  def show
    @job = Job.friendly.find(params[:id])
  end
end
