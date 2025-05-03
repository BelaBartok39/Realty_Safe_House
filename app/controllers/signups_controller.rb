class SignupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_signup, only: [ :show, :edit, :update, :destroy ]

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
    @signup = Signup.new
    @property = Property.find(params[:property_id]) if params[:property_id]
  end

  def create
    @signup = current_user.signups.build(signup_params)
    if @signup.save
      redirect_to @signup, notice: "Signup request submitted!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Optional: Only allow editing if pending and by the owner
  end

  def update
    if @signup.update(signup_params)
      redirect_to @signup, notice: "Signup updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @signup.destroy
    redirect_to signups_path, notice: "Signup deleted."
  end

  private

  def set_signup
    @signup = Signup.find(params[:id])
  end

  def signup_params
    params.require(:signup).permit(:property_id, :license_front, :license_back, :selfie)
  end
end
