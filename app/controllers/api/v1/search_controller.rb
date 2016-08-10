module Api
	module V1 
		class SearchController < Api::BaseController 
			skip_before_filter :authenticate_user!, :only => [:index]

			def index
				results = PgSearch.multisearch(params[:query])
		    video_ids = results.select { |x| x.searchable_type == 'Video' }.map(&:searchable_id)
		    @token = Opro::Oauth::AuthGrant.where(access_token: params[:access_token]).first 
				if !@token.blank?
					@b_user = Follow.where(follower_id: current_user.id, blocked: true).pluck(:followable_id)
					@videos = Video.joins(:user).where(id: video_ids).where.not(user_id: @b_user, reported: true)
				else
		    	@videos = Video.joins(:user).where(id: video_ids)
		    end
		    @results = @videos.paginate(:page => params[:page], :per_page => 10)
			end
		end
	end
end