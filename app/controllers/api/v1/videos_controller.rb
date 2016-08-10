module Api
	module V1 
		class VideosController < Api::BaseController 
			skip_before_filter :authenticate_user!, :only => [:index, :comments, :show]
			skip_before_action :verify_authenticity_token, :only => [:create]

			impressionist actions: [:show]

			def index 
				@date =Date.today - 8.day
				@views_count = Impression.where("created_at > ?", @date).pluck(:impressionable_id).uniq
				@comment = Comment.where("created_at > ?", @date).pluck(:video_id).uniq
				@vid = @views_count + @comment
				@video_id =@vid.uniq
				
				@token = Opro::Oauth::AuthGrant.where(access_token: params[:access_token]).first 
				if !@token.blank?
					@b_user = Follow.where(follower_id: current_user.id, blocked: true).pluck(:followable_id)
				  @videos = Video.joins(:user).where.not(user_id: @b_user, reported: true).where(id: @video_id).ordered.paginate(:page => params[:page], :per_page => 10)
				else
				  @videos = Video.where(id: @video_id).ordered.paginate(:page => params[:page], :per_page => 10)
				end
				@videos.each do |video|
		          if current_user 
		            video.is_like = if video.likes.where(user: current_user).count > 0
		               true 
		            else
		               false
		            end 
		          end
		        end
			end

			def report
				@video = Video.find(params[:id])
				@video.reported = true

				respond_to do |format|
					if @video.save
						format.json { render :json => @video.to_json(json_opts), status: :reported }
					else 
						format.json { render :json => @video.errors }
					end
				end
			end

			def create
				@video = current_user.videos.create(video_params)

				respond_to do |format|
					if @video.save
						format.json { render :json => @video.to_json(json_opts), status: :created }
					else 
						format.json { render :json => @video.errors }
					end
				end
			end

			def destroy
				@video = Video.find(params[:id])

				if @video.likes.any?
					@video.likes.each do |like|
						activities = Activity.where(trackable_id: like, action: "create", trackable_type: "Like").destroy_all
						like.destroy
					end	
				end

				if @video.comments.any?
					@video.comments.each do |comment|
						activities = Activity.where(trackable_id: comment, action: "create", trackable_type: "Comment").destroy_all
						comment.destroy
					end	
				end		

				@video.destroy

				respond_to do |format|
					format.json { render :json => {:status => "ok"} }
				end
			end

			def show
				@video = Video.find(params[:id])
			end

			def comments
				@video = Video.find(params[:video_id])
				@comments = @video.comments
			end

			private 

			def video_params 
				params.require(:video).permit(:reported, :description, :user_id, :title, :category_id, :video).merge(:user_id=>current_user.id)
			end

			def json_opts
				{:only => [:id, :user_id, :description, :title, :category_id, :reported]}
			end
		end
	end
end