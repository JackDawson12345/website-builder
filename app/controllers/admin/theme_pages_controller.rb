class Admin::ThemePagesController < ApplicationController
  before_action :ensure_admin
  before_action :set_theme
  before_action :set_theme_page, only: [:show, :edit, :update, :destroy, :reorder_components]

  def index
    @theme_pages = @theme.theme_pages.includes(:components).order(:position)
  end

  def show
    @available_components = Component.all.order(:name)
    @page_components = @theme_page.theme_page_components.includes(:component).order(:position)
  end

  def new
    @theme_page = @theme.theme_pages.build
    @available_page_types = ThemePage::PAGE_TYPES - @theme.theme_pages.pluck(:page_type)
  end

  def create
    @theme_page = @theme.theme_pages.build(theme_page_params)
    @theme_page.position = (@theme.theme_pages.maximum(:position) || 0) + 1

    if @theme_page.save
      redirect_to admin_theme_theme_page_path(@theme, @theme_page), notice: 'Page created successfully.'
    else
      @available_page_types = ThemePage::PAGE_TYPES - @theme.theme_pages.pluck(:page_type)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_page_types = ThemePage::PAGE_TYPES - (@theme.theme_pages.pluck(:page_type) - [@theme_page.page_type])
  end

  def update
    if @theme_page.update(theme_page_params)
      redirect_to admin_theme_theme_page_path(@theme, @theme_page), notice: 'Page updated successfully.'
    else
      @available_page_types = ThemePage::PAGE_TYPES - (@theme.theme_pages.pluck(:page_type) - [@theme_page.page_type])
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @theme_page.destroy
    redirect_to admin_theme_path(@theme), notice: 'Page deleted successfully.'
  end

  def reorder_components
    component_ids = params[:component_ids]

    component_ids.each_with_index do |component_id, index|
      theme_page_component = @theme_page.theme_page_components.find_by(component_id: component_id)
      theme_page_component&.update(position: index + 1)
    end

    head :ok
  end

  private

  def set_theme
    @theme = Theme.find(params[:theme_id])
  end

  def set_theme_page
    @theme_page = @theme.theme_pages.find(params[:id])
  end

  def theme_page_params
    params.require(:theme_page).permit(:page_type, :position)
  end
end