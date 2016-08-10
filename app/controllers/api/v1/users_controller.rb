module Api
	module V1 
		class UsersController < Api::BaseController
			before_filter :find_user_by_id_me, :except => [:create, :token_auth, :blocklist]
		    skip_before_action :verify_authenticity_token, :only => [:create, :token_auth, :blocklist, :liked]
		    skip_before_filter :authenticate_user!, :only => [:create, :followers, :following, :videos, :token_auth, :block, :blocklist]
		    before_filter :authenticate_on_create, :only => [:create, :token_auth]
 				
			def show
				@videos = @user.videos.paginate(:page => params[:page], :per_page => 10)
			end

			def create
				@user = User.create(create_user_params)

				respond_to do |format|
					if @user.save
						sign_in(@user, :bypass => true)
						User.follow_accounts(@user)
				        format.json { render :json => @user.to_json(json_opts), status: :created }
					else 
						format.json { render :json => @user.errors }
					end
				end
			end

			def followers
				@followers = @user.followers_by_type('User')
			end

			def following
				@following = @user.following_users
			end

			def block
				if (params[:block_state]).to_i == 1
				  @block = Follow.where(follower_id: @user.id, followable_id: params[:block_id]).first
				  if @block.blank?
					  Follow.create(:follower_id => @user.id, :followable_id => params[:block_id], :blocked => true, :followable_type => "User" , :follower_type => "User")
				  else
					  @block.update_attribute(:blocked, true)
				  end
					respond_to do |format|
					  format.json { render :json => {:status => "ok"} }
					end
				elsif (params[:block_state]).to_i == 0
					@block = Follow.where(follower_id: @user.id, followable_id: params[:block_id], blocked: true).first
				  if @block.blank?
					  respond_to do |format|
					    format.json { render :json => {:status => "error"} }
					  end
				  else
					  @block.destroy
						respond_to do |format|
					    format.json { render :json => {:status => "ok"} }
					  end
				  end
			  end
			end

			def blocklist
				@b_user = Follow.where(follower_id: current_user.id, blocked: true).pluck(:followable_id)
				@user = User.where(id: @b_user)
			end

			def liked
				@liked = Like.where(user_id: current_user.id).paginate(:page => params[:page], :per_page => 10)
			  if @liked.blank?
				  respond_to do |format|
					    format.json { render :json => {:status => "no likes done"} }
					  end
				else
					@liked
				end
			end

			def videos 
				@videos = @user.videos.paginate(:page => params[:page], :per_page => 10)
			end

			def feed
				 @videos = @user.feed.paginate(:page => params[:page], :per_page => 10)
				# @like = Like.where(user_id: current_user.id).pluck(:video_id)
				# @vid3= (Video.where(user_id: current_user.id) + Video.where(id: @like)).uniq
				# @videos=@vid3.paginate(:page => params[:page], :per_page => 10)		
			end

			def notifications
				@notifications = @user.notifications
			end

			def update
				if @user.update_attributes(user_params)
					render :json => @user.to_json(json_opts), status: :ok
				else
					render json: @user.errors, status: :unprocessable_entity
				end
			end 
			def token_auth
				@token = Opro::Oauth::AuthGrant.where(access_token: params[:access_token]).first 
				if !@token.blank?
					@user = User.find(@token.user_id.to_i)
					respond_to do |format|
						format.json { render json: {status: "valid token", id: @user.id , name: @user.name, email: @user.email } }
					end
				else
					respond_to do |format|
						format.json { render :json => {:status => "Invalid token"} }
					end
				end
			end

			private

			def find_user_by_id_me
				@user = find_user(params[:id])
			end

			def create_user_params
				params.require(:user).permit(:name, :password, :email, :avatar, :avatar_file_name, :description).tap {|p| p[:password_confirmation]=p[:password]}
			end

			def user_params 
				params.require(:user).permit(:name, :password, :email, :avatar, :avatar_file_name, :description)
			end

			def authenticate_on_create
				@opro_client = Opro::Oauth::ClientApp.authenticate(params[:client_id],params[:client_secret])
				unauthorized_on_create unless @opro_client
			end

			def json_opts
				{:only => [:id, :name, :email], :base_url=>request.url}
			end

			def unauthorized_on_create
				result = {status: :unauthorized, message: "For create use specify a valid client_id an client_secret!"}
				respond_to do |format|
					format.html do
						render :text => result.to_json, :status => result[:status], :layout => true
					end
					format.json do
						render :json => result, :status => result[:status]
					end
				end
			end
		end
	end
end
