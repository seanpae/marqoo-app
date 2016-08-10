module Api
	module V1 
		class FollowController < Api::BaseController 
			before_filter :find_user_by_id_me
      		skip_before_action :verify_authenticity_token

			def update
				@followed_user = User.find(params[:id])
		        @user.follow(@followed_user)

		        trackable_user = @user
        		track_activity @followed_user, trackable_user

		        respond_to do |format|
		          format.json { render :json => { :status=>"ok" } }
		        end
			end

			def destroy
				@followed_user = User.find(params[:id])
		        @user.stop_following(@followed_user)

		        respond_to do |format|
		          format.json { render :json => { :status=>"ok" } }
		        end
			end

			def index
				@following = @user.following_users
			end

			private

			def find_user_by_id_me
        		@user = find_user(params[:user_id])
      		end 
		end
	end
end