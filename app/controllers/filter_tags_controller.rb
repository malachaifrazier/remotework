class FilterTagsController < ApplicationController
  def create
    path = Rails.application.routes.recognize_path(request.referrer)
    tags = (path[:tags].split('+') || []) + [params[:tag_name]]
    path[:tags] = tags.join('+')
    redirect_to url_for(path)
  end

  def destroy
    path = Rails.application.routes.recognize_path(request.referrer)
    tags = (path[:tags].split('+') || []) - [params[:id]]
    redirect_to root_path and return if tags.blank? && params[:category].blank?
    redirect_to category_path(params[:category]) and return if tags.blank? && !params[:category].blank?
    path[:tags] = tags.join('+')
    redirect_to url_for(path)
  end
end
