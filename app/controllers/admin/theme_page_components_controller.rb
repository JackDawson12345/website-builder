class Admin::ThemePageComponentsController < ApplicationController
  before_action :ensure_admin
  before_action :set_theme_and_page

  def create
    component = Component.find(params[:component_id])
    position = (@theme_page.theme_page_components.maximum(:position) || 0) + 1

    @theme_page_component = @theme_page.theme_page_components.build(
      component: component,
      position: position
    )

    if @theme_page_component.save
      redirect_to admin_theme_theme_page_path(@theme, @theme_page),
                  notice: 'Component added to page successfully.'
    else
      redirect_to admin_theme_theme_page_path(@theme, @theme_page),
                  alert: 'Failed to add component to page.'
    end
  end

  def destroy
    @theme_page_component = @theme_page.theme_page_components.find(params[:id])
    @theme_page_component.destroy

    redirect_to admin_theme_theme_page_path(@theme, @theme_page),
                notice: 'Component removed from page successfully.'
  end

  private

  def set_theme_and_page
    @theme = Theme.find(params[:theme_id])
    @theme_page = @theme.theme_pages.find(params[:theme_page_id])
  end
end