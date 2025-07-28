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
      redirect_to edit_customer_website_path(page: params[:current_page]),
                  notice: 'Content updated successfully!'
    else
      @component = @content.component
      @current_page = params[:current_page] || 'home'
      render :edit, status: :unprocessable_entity
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
end