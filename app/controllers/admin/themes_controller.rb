class Admin::ThemesController < ApplicationController
  before_action :ensure_admin
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  def index
    @themes = Theme.includes(:theme_pages).order(:name)
  end

  def show
    @theme_pages = @theme.theme_pages.includes(:components).order(:position)
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      # Create default pages for the theme
      create_default_pages_for_theme(@theme)
      redirect_to admin_theme_path(@theme), notice: 'Theme created successfully with default pages.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @theme.update(theme_params)
      redirect_to admin_theme_path(@theme), notice: 'Theme updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @theme.websites.any?
      redirect_to admin_themes_path, alert: 'Cannot delete theme that is being used by websites.'
    else
      @theme.destroy
      redirect_to admin_themes_path, notice: 'Theme deleted successfully.'
    end
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(:name, :description, :placeholder_image)
  end

  def create_default_pages_for_theme(theme)
    default_pages = [
      { page_type: 'home', position: 1 },
      { page_type: 'about_us', position: 2 },
      { page_type: 'services', position: 3 },
      { page_type: 'contact_us', position: 4 }
    ]

    default_pages.each do |page_data|
      theme.theme_pages.create!(page_data)
    end
  end
end