class JobsController < ApplicationController
  def index
    @tags = (params[:tags] || '').split('+')
    @jobs = Job.for_tags(@tags).order('posted_at DESC').page(params[:page] || 1)
    render 'index', layout: 'listings'
  end

  def show
    @job = Job.friendly.find(params[:id])
  end
end
