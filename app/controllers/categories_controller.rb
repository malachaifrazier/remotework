class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(name: params[:id])
    j = @category ? @category.jobs : Job.eager_load(:category).all
    @jobs = j.order('posted_at DESC').page(params[:page] || 1)
    respond_to do |format|
      format.html { render partial: 'shared/jobs_list', locals: {jobs: @jobs} }
      format.js {}
    end
  end
end
