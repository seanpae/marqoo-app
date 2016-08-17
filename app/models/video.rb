class Video < ActiveRecord::Base
	belongs_to :user
  belongs_to :category

  # is_impressionable
	is_impressionable :counter_cache => true, :column_name => :view_count, :unique => :all

	has_many :likes
	has_many :comments   

  attr_accessor :is_like 
  scope :ordered, -> { reorder('videos.view_count DESC') }

	default_scope -> { order('videos.created_at DESC') }
 
  has_attached_file :video, :styles => {
    :medium => { :geometry => "200x200<", :format => 'mp4'},
    :thumb => { :geometry => "600x600#", :format => 'jpg', :time => 2, :auto_rotate => true}
   },:processors => [:ffmpeg, :qtfaststart],
  # :processors => [:transcoder],
    :storage => "s3",
    :s3_credentials => {
          :bucket => ENV["aws_bucket"],
          :access_key_id => ENV["aws_access_key"],
          :secret_access_key => ENV["aws_secret_access"]
      },
      :url => ":s3_domain_url",
      :s3_protocol => :https, 
      :path => "/:class/:attachment/:id_partition/:style/:filename"

      validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/

  validates :user_id, presence: true
  validates :category_id, presence: true

  include PgSearch 
  multisearchable :against => [:title, :description]


  def self.views
    @videos = Video.all
    @videos.each do |v|

      count = v.impressionist_count
      if count > 0
        v.update_attributes(view_count: count)
      end
    end

  end
  def self.l_count(id)
    @v=find(id)
    @v.update(:likes_count => @v.likes.count)
  end
  # def self.count_sub(id)
  #   @v=find(id)
  #   tot=@v.likes_count.to_i - 1
  #   @v.update(:likes_count => tot)
  # end
=begin
  def self.get_comedy_three

   media=HTTParty.get "https://api.vineapp.com/timelines/users/953769986197995520"
   
    media.each do |index,post|
      if index == "data"
       post.each do |index, data|
        if index == "records"
           data.each do |da|
            id = where(video_id: da['postId'])
             if id.blank?
                create!(
                video_id: da['postId'],
                video_source: da['videoDashUrl'],
                thumbnail_url: da['thumbnailUrl'],
                created_at: da['created'],
                category_id: 8,
                user_id: 11,
                title: "Comedy",
                description: da['description'],
                )
            end
          end
        end
       end
      end
    end
  end
=end
  def self.get_fight_one
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UC-IL1rtOP8E_qs-0JdFvqIg")
  
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 9,
            user_id: 54 ,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_fight_two
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCbLmHT1GF98oRlqS958wQuw")
  
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 9,
            user_id: 54 ,
            title: data.title,
            description: data.description,
          )
      end
     end
  end


def self.get_comedy_feed1
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCqoDKjJF4OLSD8BH6RabUDw")
  feed.entries.each do |data|
      id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_comedy_feed2
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCkcKT7MgTnkvkX4URG6tXTg")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_comedy_feed3
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCXHbZT4B4EVDKA_faF_7fYQ")
  feed.entries.each do |data|
       id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
       end
     end
  end

  def self.get_comedy_feed4
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UC1H1S5yLiYDZ3I0P5_pIvUg")
  feed.entries.each do |data|
      unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

   def self.get_comedy_feed5
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCeB0K8AL2mCJhrBdCeD2BgA")
  feed.entries.each do |data|
      unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_comedy_feed6
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCRn1bCS4MnYXQkFTTHdNyMA")
  feed.entries.each do |data|
      unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_comedy_feed7
   Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCxWaUjAzfRXCCp9D5IHa27A")
  feed.entries.each do |data|
      unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 8,
            user_id: 11,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_sports_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCgn8FJpkMLJWed7vkvsV0mg")
  feed.entries.each do |data|
      id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 7,
            user_id: 12,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_sports_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCZVhyqi9QA74rDYhheS9U-A")
  feed.entries.each do |data|
     id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 7,
            user_id: 12,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

   def self.get_sports_feed3
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCrLamXyxmMYuhJGKMzmzjAg")
  feed.entries.each do |data|
     id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 7,
            user_id: 12,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCztGY3Qsxxk7JDSY3Q_iXsw")
  feed.entries.each do |data|
     id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCJ0JGjHrhqNGIQJ4uHAYfjw")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed3
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCwD7SM8nbG6Cl_xDoHc2XQg")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed4
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCbdkuPpLhaMO8-ASIULFFaA")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed5
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCMQ7VIzsTykE5-FvHCqFmHg")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed6
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCeiO4WkOBrXEP2j6k-u7aNA")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed7
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCIuFtIO8i_XqA8lM7q4B1FQ")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed8
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UC8QfB1wbfrNwNFHQxfyNJsw")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

   def self.get_music_feed9
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCUnSTiCHiHgZA9NQUG6lZkQ")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed10
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCoMb7EJoVAaOs-BrXDC-S-w")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_music_feed11
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCoMb7EJoVAaOs-BrXDC-S-w")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 5,
            user_id: 14,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_entertainment_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCqp6OhEmlbH1WpPObE9DFbg")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 1,
            user_id: 18,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_entertainment_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCmvZHcoAJGXAUnzPmBGD-SA")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 1,
            user_id: 18,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

   def self.get_entertainment_feed3
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UC0vRcJh1-GQL_V4qm5F6xFw")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 1,
            user_id: 18,
            title: data.title,
            description: data.description,
          )
        end
     end
  end
  
  def self.get_beauty_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCvM7efGeikAsDnsBr3MmL5g")
  feed.entries.each do |data|
    id = where(video_id: data.id.to_s)
       if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 4,
            user_id: 15,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_beauty_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCN28EV2KEkBr_7xLjA78_JA")
  feed.entries.each do |data|
    # id = where(video_id: data.id.to_s)
    unless exists?(video_id: data.id.to_s)
       # if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 4,
            user_id: 15,
            title: data.title,
            description: data.description,
          )
        end
     end
  end


  def self.get_fashion_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCUrSIrwUdBFC52Mz73c5irQ")
  feed.entries.each do |data|
    # id = where(video_id: data.id.to_s)
    unless exists?(video_id: data.id.to_s)
       # if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 3,
            user_id: 16,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

def self.get_fashion_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCIVM3-CW8t3DWDAfm88P27Q")
  feed.entries.each do |data|
    # id = where(video_id: data.id.to_s)
    unless exists?(video_id: data.id.to_s)
       # if id.blank?
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 3,
            user_id: 16,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_fashion_feed3
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCC1Dni2gMTl0YT8LNpGbZcQ")
  feed.entries.each do |data| 
    unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 3,
            user_id: 16,
            title: data.title,
            description: data.description,
          )
        end
     end
  end

  def self.get_new_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCQcPBLsq9rRc5TxDqSz_Dog")
  feed.entries.each do |data|
    unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 6,
            user_id: 13,
            title: data.title,
            description: data.description,
          )
        end
          
     end
  end

def self.get_new_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCpFHkjOa7ia6bH5_6cDsDXg")
  feed.entries.each do |data|
    unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 6,
            user_id: 13,
            title: data.title,
            description: data.description,
          )
        end
          
     end
  end

def self.get_new_feed3
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UC-OO324clObi3H-U0bP77dw")
  feed.entries.each do |data|
    unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 6,
            user_id: 13,
            title: data.title,
            description: data.description,
          )
        end
          
     end
  end

  def self.get_faith_feed1
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCdF-MldtDn4EW8-DlQqPD_g")
  feed.entries.each do |data|
    unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 2,
            user_id: 17,
            title: data.title,
            description: data.description,
          )
        end
          
     end
  end

def self.get_faith_feed2
    Feedjira::Feed.add_common_feed_entry_element("media:thumbnail",:value => :url, :as => :thumbnail)
    Feedjira::Feed.add_common_feed_entry_element("media:description", :as => :description)
  feed = Feedjira::Feed.fetch_and_parse("https://www.youtube.com/feeds/videos.xml?channel_id=UCSJXkctJ2vLbaP35yy-VPMQ")
  feed.entries.each do |data|
    unless exists?(video_id: data.id.to_s)
          create!(
            video_id: data.id.to_s,
            video_source: data.url,
            thumbnail_url:data.thumbnail,
            created_at: data.published,
            category_id: 2,
            user_id: 17,
            title: data.title,
            description: data.description,
          )
          # puts data.id.to_s
          # puts data.url
          # puts data.thumbnail
          # puts data.published
          # puts data.title
          # puts data.description
        end
          
     end
  end

  def self.trending_videos
    likes = Like.where("created_at >= ?", Time.now - 24.hours).select(:video_id)
    trending = Video.where(id: likes)
    trending.order("COALESCE(likes_count, 0) DESC").limit(3)
  end
end
