class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates :feed_name, :presence => true
  validates :link, :presence => true, :unless => :urlcheck?

  def urlcheck?
  	begin
      feed = Feedjira::Feed.fetch_and_parse(link)
      return true
  	rescue Exception
  		errors.add(:link, "url is WRONG")
 			return false
		end
  end
end
