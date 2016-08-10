module Api
	module V1 
		class LikesController < Api::BaseController 
			skip_before_filter :verify_authenticity_token, :only => [:create, :destroy]


			def create
				@like = current_user.likes.create(:video_id => params[:video_id])
				
				if @like.save
					trackable_user = Video.find(params[:video_id]).user.id
	     			track_activity @like, trackable_user
	     		respond_to do |format|
					format.json { render :json => {:status=>"ok"} }
				end
				else
					respond_to do |format|
						format.json { render :json => {:status=>"error"} }
					end
				end
				Video.l_count(params[:video_id])
			end

			def destroy
				video = Video.find(params[:id])
				user = current_user
				@like = Like.where(video_id: video.id, user_id: user.id).first
			
				if !@like.blank?
					 @activity = Activity.where(trackable_id: @like.id, action: "create", user_id: current_user.id, trackable_type: "Like").first
   				 	@activity.destroy

				  @like.destroy
				  Video.l_count(params[:id])
					respond_to do |format|
					 format.json { render :json => {:status => "ok"} }
					end
				else
					respond_to do |format|
					format.json { render :json => {:status=>"error"} }
					end
				end
			end
		end
	end
end 