class Customer::ContentsController < ApplicationController
  before_action :ensure_customer
  before_action :set_website
  before_action :set_content, only: [:edit, :update]

  def edit
    @component = @content.component
    @current_page = params[:page] || 'home'
  end

  def update
    content_data = {}

    # Process the submitted content fields
    if params[:content].present?
      params[:content].each do |field, value|
        content_data[field] = value
      end
    end

    @content.content = content_data.to_json

    if @content.save
      respond_to do |format|
        format.html do
          redirect_to edit_customer_website_path(page: params[:current_page]),
                      notice: 'Content updated successfully!'
        end
        format.json do
          # Return the updated component HTML for AJAX requests
          updated_html = render_component_with_user_content(@content.component, @content)
          render json: {
            success: true,
            message: 'Content updated successfully!',
            updated_content: updated_html
          }
        end
      end
    else
      respond_to do |format|
        format.html do
          @component = @content.component
          @current_page = params[:current_page] || 'home'
          render :edit, status: :unprocessable_entity
        end
        format.json do
          render json: {
            success: false,
            error: @content.errors.full_messages.join(', ')
          }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_website
    @website = current_user.website
    redirect_to customer_website_path, alert: 'Please create a website first.' unless @website
  end

  def set_content
    @content = @website.website_contents.find(params[:id])
  end

  # Include the application helper methods for rendering components
  include ApplicationHelper
end