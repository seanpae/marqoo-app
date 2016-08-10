class StaticpageController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:terms_condition, :privacy_policy]
	def terms_condition
		render :layout => false  
	end
	def  privacy_policy
		render :layout => false
	end
end
	