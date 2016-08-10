module Api
	module V1 
		class CategoriesController < Api::BaseController 
			skip_before_filter :authenticate_user!, :only => [:index, :show ]

			def index

				@token = Opro::Oauth::AuthGrant.where(access_token: params[:access_token]).first 
				if !@token.blank?
					@b_user = Follow.where(follower_id: current_user.id, blocked: true).pluck(:followable_id)
				end
				@categories = Category.all.order('sequence_number')
				 #  @my_array = ['http://192.168.0.129:3000/api/v1/comedy.jpg',
					# 'http://192.168.0.129:3000/api/v1/sports.jpg',
					# 'http://192.168.0.129:3000/api/v1/fights.jpg',
					# 'http://192.168.0.129:3000/api/v1/music.jpg',
					# 'http://192.168.0.129:3000/api/v1/entertainment.jpg',
					# 'http://192.168.0.129:3000/api/v1/beauty2.jpg',
					# 'http://192.168.0.129:3000/api/v1/fashion.jpg',
					# 'http://192.168.0.129:3000/api/v1/news.jpg',
					# 'http://192.168.0.129:3000/api/v1/faith.png']
					@my_array = ['https://marqoo-app.herokuapp.com/api/v1/comedy.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/sports.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/fights.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/music.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/entertainment.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/beauty2.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/fashion.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/news.jpg',
					'https://marqoo-app.herokuapp.com/api/v1/faith.png']
			end

			def show
				@category = Category.find(params[:id])
				if @category.blank?
					respond_to do |format|
					  format.json { render :json => {:status => "wrong category id"} }
					end
				else
					
					@videos = Video.joins(:user).where(category_id: params[:id]).paginate(:page => params[:page], :per_page => 10)
				  # @videos = Video.joins("INNER JOIN users ON users.id = videos.user_id").paginate(:page => params[:page], :per_page => 10)
					# @videos =@category.videos.paginate(:page => params[:page], :per_page => 10)
				end
			end

			def show_like
				@category = Category.find(params[:id])
				if @category.blank?
					respond_to do |format|
					  format.json { render :json => {:status => "wrong category id"} }
					end
				else
				  @b_user = Follow.where(follower_id: current_user.id, blocked: true).pluck(:followable_id)
				  @videos = Video.joins(:user).where(category_id: params[:id]).where.not(user_id: @b_user, reported: true).paginate(:page => params[:page], :per_page => 10)
			 end
			end
		end
	end
end