class JobsController < ApplicationController
  def index
    @tags = (params[:tags] || '').split('+')
    @q = params[:q]
    query = Job.for_tags(@tags).order('posted_at DESC')
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
    @job = Job.new
  end
end
