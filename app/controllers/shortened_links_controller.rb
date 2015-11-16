# -*- coding: utf-8 -*-
class ShortenedLinksController < ApplicationController
  def show
    redirect_to(LinkShorteningService.new.long_url(params[:id]), host: Rails.application.config.raj_host)
  end
end
