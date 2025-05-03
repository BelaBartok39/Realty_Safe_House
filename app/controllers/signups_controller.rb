class SignupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [ :new, :create ]
  before_action :require_client!, only: [ :new, :create ]
  before_action :set_signup, only: [ :show, :update ] # Add :update
  before_action :authorize_signup_viewer!, only: [ :show ]
  before_action :authorize_signup_updater!, only: [ :update ] # Add authorization for update

  def index
    if current_user.realtor?
      @signups = Signup.joins(:property).where(properties: { realtor_id: current_user.id }).includes(:property, :user)
    else
      @signups = current_user.signups.includes(:property)
    end
  end

  def show
    # @signup is set by before_action
  end

  def new
    # @property is set by before_action
    @signup = @property.signups.build(user: current_user)
  end

  def create
    # @property is set by before_action
    @signup = @property.signups.build(user: current_user)
    @signup.status = "pending" # Explicitly set initial status

    if @signup.save
      redirect_to signup_path(@signup), notice: "Request submitted successfully. You will be notified upon approval."
    else
      # Need to set @property again if rendering new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @signup.update(signup_params)
      # TODO: Add notification logic later (e.g., email client)
      redirect_to signup_path(@signup), notice: "Signup status updated successfully."
    else
      # If update fails, redirect back to the signup page with an alert
      redirect_to signup_path(@signup), alert: "Failed to update signup status."
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Property not found."
  end

  def set_signup
    @signup = Signup.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Signup not found."
  end

  def require_client!
    redirect_to root_path, alert: "Only clients can request attendance." unless current_user.client?
  end

  def authorize_signup_viewer!
    # Allow viewing if it's the client's own signup OR if it belongs to a property managed by the realtor
    is_owner = @signup.user == current_user
    is_realtor_of_property = current_user.realtor? && @signup.property.realtor == current_user
    redirect_to root_path, alert: "You are not authorized to view this signup." unless is_owner || is_realtor_of_property
  end

  def authorize_signup_updater!
    # Only allow updating if the current user is a realtor AND owns the property associated with the signup
    is_realtor_of_property = current_user.realtor? && @signup.property.realtor == current_user
    redirect_to root_path, alert: "You are not authorized to update this signup." unless is_realtor_of_property
  end

  def signup_params
    params.require(:signup).permit(:status)
  end
end
