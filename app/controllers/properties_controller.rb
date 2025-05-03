class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :require_realtor!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_property, only: [ :show, :edit, :update, :destroy ]

  def index
    @properties = Property.with_attached_image.all # Eager load the image attachment
  end

  def show
    # @property is set by before_action
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    @property.realtor = current_user if user_signed_in? && current_user.realtor?
    if @property.save
      redirect_to @property, notice: "Property was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @property is set by before_action
  end

  def update
    if @property.update(property_params)
      redirect_to @property, notice: "Property was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path, notice: "Property was successfully deleted."
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :description, :address, :start_time, :end_time, :image)
  end

  def require_realtor!
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.realtor?
  end
end
