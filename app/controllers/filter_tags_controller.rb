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
    path[:tags] = tags.join('+')
    redirect_to url_for(path)
  end
end
