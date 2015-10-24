class FilterTagsController < ApplicationController
  def create
    path = Rails.application.routes.recognize_path(request.referrer)
    tags = (path[:tags].split('+') || []) + [params[:tag_name]]
    path[:tags] = tags.join('+')
    redirect_to url_for(path)
  end

  def destroy
    path = Rails.application.routes.recognize_path(request.referrer)
    @q = params[:q]
    tags = (path[:tags] || '').split('+') - [params[:id]]
    redirect_to jobs_path(q: @q) and return if tags.empty?
    path[:tags] = tags.join('+')
    path[:q] = @q if @q.present?
    redirect_to url_for(path)
  end
end
