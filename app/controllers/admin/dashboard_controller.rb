class Admin::DashboardController < ApplicationController
  before_action :ensure_admin

  def index
    @components_count = Component.count
    @themes_count = Theme.count
    @websites_count = Website.count
    @recent_websites = Website.includes(:user, :theme).limit(10).order(created_at: :desc)
  end
end