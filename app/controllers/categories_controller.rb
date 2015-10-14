class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(name: params[:id])
    j = @category ? @category.jobs : Job.eager_load(:category).all
    @jobs = j.order('posted_at DESC').page(params[:page] || 1)
    render 'show', layout: 'listings'
  end
end
