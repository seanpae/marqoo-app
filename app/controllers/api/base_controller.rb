module Api
  class BaseController < ApplicationController
    allow_oauth!
 
    before_filter :authenticate_user!

    before_filter :configure_devise_params, if: :devise_controller?
    def configure_devise_params
      devise_parameter_sanitizer.for(:create) do |u|
        u.permit(:first_name, :location, :influencer, :email, :password, :password_confirmation, :instagram_username, :longitude, :latitude)
      end
    end

    skip_before_action :verify_authenticity_token, if: :json_oauth_request?

    respond_to :json

    def find_user(id)
      @user = current_user if id=='me'
      @user ||= User.find(id)
    end

   private

    def json_oauth_request?
      oauth? && request.format.json?
    end
  end
end
