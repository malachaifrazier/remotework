class JobsController < ApplicationController
  def index
    @jobs = Job.all.order('posted_at desc').page(params[:page] || 1).per(30)
    render partial: 'shared/jobs_list', locals: {jobs: @jobs}
  end
end
