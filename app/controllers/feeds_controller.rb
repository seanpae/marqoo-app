class FeedsController < InheritedResources::Base

  private

    def feed_params
      params.require(:feed).permit(:feed_name, :link)
    end
end

