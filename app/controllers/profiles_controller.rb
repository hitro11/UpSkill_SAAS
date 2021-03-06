class ProfilesController < ApplicationController
  
  before_action :authenticate_user! #can't interact with profiles unless you're logged in
  before_action :only_current_user #can't interact with profiles other than your own
  
  # GET to /users/:user_id/profile/new
  def new
    @profile = Profile.new
  end
  
  def create
      @user = User.find(params[:user_id])
      @profile = @user.build_profile(profile_params)
      
      if @profile.save
        redirect_to user_path(id: current_user.id)
      else
        render action: :new
      end
  end
  
  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end
  
  #put or patch request for profiles
  def update
     @user = User.find(params[:user_id])
     @profile = @user.profile
     
    if @profile.update_attributes(profile_params)
      redirect_to user_path(current_user.id)
    else
      render action: :edit
    end
  end
  
 private
 
      #to collect data from forms, need to use strong params and whitelist form fields.
      def profile_params
          params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :email, :phone_num, :description)
      end
      
      def only_current_user
        @user = User.find(params[:user_id])
        redirect_to root_path unless @user == current_user
      end
end