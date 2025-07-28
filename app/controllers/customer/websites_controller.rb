class Customer::WebsitesController < ApplicationController
  before_action :ensure_customer
  before_action :set_website, only: [:edit, :update, :preview, :publish, :unpublish, :settings, :update_settings]

  def show
    @website = current_user.website

    if @website
      redirect_to edit_customer_website_path
    else
      @themes = Theme.includes(:theme_pages, :websites).all
    end
  end

  def new
    redirect_to customer_website_path
  end

  def create
    if current_user.website
      redirect_to customer_website_path, alert: 'You already have a website.'
      return
    end

    theme = Theme.find(params[:theme_id])

    @website = current_user.build_website(
      theme: theme,
      name: params[:website_name] || "#{current_user.email.split('@').first.humanize}'s Website",
      published: false
    )

    if @website.save
      # Create default content for all components in the theme
      create_default_website_content(@website)
      redirect_to edit_customer_website_path, notice: 'Website created successfully! You can now customize your content.'
    else
      @themes = Theme.includes(:theme_pages, :websites).all
      render :show, status: :unprocessable_entity
    end
  end

  def edit
    @current_page = params[:page] || 'home'
    @theme_pages = @website.theme.theme_pages.includes(theme_page_components: :component).order(:position)
    @current_theme_page = @theme_pages.find_by(page_type: @current_page) || @theme_pages.first
    @page_components = @current_theme_page&.theme_page_components&.includes(:component)&.order(:position) || []
  end

  def update
    if @website.update(website_params)
      redirect_to edit_customer_website_path(page: params[:current_page]), notice: 'Website settings updated successfully.'
    else
      @current_page = params[:current_page] || 'home'
      @theme_pages = @website.theme.theme_pages.includes(theme_page_components: :component).order(:position)
      @current_theme_page = @theme_pages.find_by(page_type: @current_page) || @theme_pages.first
      @page_components = @current_theme_page&.theme_page_components&.includes(:component)&.order(:position) || []
      render :edit, status: :unprocessable_entity
    end
  end

  # New settings action
  def settings
    # Just render the settings page
  end

  # New update_settings action
  def update_settings
    if @website.update(website_params)
      redirect_to settings_customer_website_path, notice: 'Website settings updated successfully.'
    else
      render :settings, status: :unprocessable_entity
    end
  end

  def preview
    @current_page = params[:page] || 'home'
    @theme_pages = @website.theme.theme_pages.includes(theme_page_components: :component).order(:position)
    @current_theme_page = @theme_pages.find_by(page_type: @current_page) || @theme_pages.first

    render layout: 'website_preview'
  end

  def publish
    @website.update(published: true)
    redirect_to edit_customer_website_path, notice: 'Website published successfully!'
  end

  def unpublish
    @website.update(published: false)
    redirect_to edit_customer_website_path, notice: 'Website unpublished.'
  end

  private

  def set_website
    @website = current_user.website

    if @website.nil?
      redirect_to customer_website_path, alert: 'Please create a website first.'
    end
  end

  def website_params
    params.require(:website).permit(:name, :subdomain)
  end

  def create_default_website_content(website)
    # Create website content for all components in the theme
    website.theme.theme_pages.each do |theme_page|
      theme_page.components.each do |component|
        content_data = generate_default_content_for_component(component)

        website.website_contents.create!(
          component: component,
          content: content_data.to_json
        )
      end
    end
  end

  def generate_default_content_for_component(component)
    default_content = {}

    component.editable_fields_array.each do |field|
      default_content[field] = case field.downcase
                               when 'title', 'headline'
                                 'Your Company Name'
                               when 'subtitle', 'subheadline'
                                 'Professional Services & Solutions'
                               when 'description', 'content'
                                 'Welcome to our company. We provide excellent services and solutions for your business needs.'
                               when 'cta_text'
                                 'Contact Us'
                               when 'name'
                                 'Your Name'
                               when 'email'
                                 current_user.email
                               when 'phone'
                                 '(555) 123-4567'
                               when 'address'
                                 'Your Business Address'
                               when 'navigation'
                                 'Home | About | Services | Contact'
                               else
                                 "Your #{field.humanize}"
                               end
    end

    default_content
  end
end