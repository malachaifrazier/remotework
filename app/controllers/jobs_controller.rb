class JobsController < ApplicationController
  def index
    @tags = (params[:tags] || '').split('+')
    @q = params[:q]
    query = Job.for_tags(@tags).order('posted_at DESC')
    query = query.search(@q) if @q.present?
    @jobs = query.page(params[:page] || 1)
    render 'index', layout: 'listings'
  end

  def show
    @job = Job.friendly.find(params[:id])
  end

  def new
    @job = Job.new
  end
end
