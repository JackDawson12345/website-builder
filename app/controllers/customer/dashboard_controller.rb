class Customer::DashboardController < ApplicationController
  before_action :ensure_customer

  def index
    @website = current_user.website
    @available_themes = Theme.includes(:theme_pages).all
    @recent_activity = []

    if @website
      @website_stats = {
        pages: @website.theme.theme_pages.count,
        components: @website.website_contents.count,
        last_updated: @website.updated_at
      }
    end
  end
end