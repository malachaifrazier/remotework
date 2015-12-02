class Admin::BaseController < ApplicationController
  before_filter :ensure_admin
  layout 'admin'

  private

  def ensure_admin
    render_404 and return unless current_user && current_user.admin?
  end
end
