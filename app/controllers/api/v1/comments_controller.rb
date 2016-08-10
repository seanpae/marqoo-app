module Api
  module V1
    class CommentsController < Api::BaseController
    	skip_before_filter :verify_authenticity_token, :only => [:create]

    	def create
			   @video = Video.find(params[:comment][:video_id])
         @comment = @video.comments.create(comment_params)

        	respond_to do |format|
          		if @comment.save
                
                trackable_user = @video.user.id
                track_activity @comment, trackable_user

            		format.json { render :json => @comment.to_json(json_opts), status: :created }
          		else
            		format.json { render :json => @comment.errors }
         		end
       		end
    	end

    	def destroy
        @comment = Comment.find(params[:id])
        
        @activity = Activity.where(trackable_id: @comment.id, action: "create", user_id: current_user.id, trackable_type: "Comment").first
        @activity.destroy


      	@comment.destroy
      	respond_to do |format|
        		format.json { render json: {status: :ok, notes:"removed comment!"} }
      	end
      end

    	private

	    def comment_params
    		params.require(:comment).permit(:content, :user_id, :video_id).merge(:user_id=>current_user.id)
  		end

	    def json_opts
	       {:only => [:id, :user_id, :content, :video_id]}
	    end
    end
  end
end