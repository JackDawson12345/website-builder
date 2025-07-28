class Admin::ComponentsController < ApplicationController
  before_action :ensure_admin
  before_action :set_component, only: [:show, :edit, :update, :destroy, :preview]

  def index
    @components = Component.all.order(:name)
  end

  def show
  end

  def new
    @component = Component.new
    @component.editable_fields = '[]'
  end

  def create
    @component = Component.new(component_params)

    # Ensure editable_fields is properly formatted
    if params[:component][:editable_fields].present?
      @component.editable_fields = params[:component][:editable_fields]
    else
      @component.editable_fields = '[]'
    end

    if @component.save
      redirect_to admin_component_path(@component), notice: 'Component created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Handle editable_fields update
    if params[:component][:editable_fields].present?
      component_params_with_fields = component_params.merge(
        editable_fields: params[:component][:editable_fields]
      )
    else
      component_params_with_fields = component_params.merge(
        editable_fields: '[]'
      )
    end

    if @component.update(component_params_with_fields)
      redirect_to admin_component_path(@component), notice: 'Component updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @component.destroy
    redirect_to admin_components_path, notice: 'Component deleted successfully.'
  end

  def preview
    render layout: false
  end

  private

  def set_component
    @component = Component.find(params[:id])
  end

  def component_params
    params.require(:component).permit(:name, :html_content, :css_content, :js_content, :component_type)
  end
end