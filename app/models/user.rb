class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
# validates :description, length: { in: 6..20 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 
  has_many :videos
  has_many :comments
  has_many :likes
  has_many :activities 
  has_many :feeds
  acts_as_followable
  acts_as_follower

  has_attached_file :avatar,  
     :storage => "s3",
     :s3_credentials => {
         :bucket => ENV["aws_bucket"],
          :access_key_id => ENV["aws_access_key"],
          :secret_access_key => ENV["aws_secret_access"]
      },
      :url => ":s3_domain_url",
      :s3_protocol => :https,
      :path => "/:class/:attachment/:id_partition/:style/:filename",
      :styles => { :thumb => "75x75^", :large => "100x100^" },
      :convert_options => { :thumb => " -gravity center -crop '60x60+0+0'", :large => " -gravity center -crop '2000x200+0+0'"},
      # :default_url => 'https://s3-us-west-2.amazonaws.com/marqoo/default.jpg'
      :default_url => 'https://s3.amazonaws.com/marqoomedia/default.jpg'
      validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


  def self.follow_accounts(user)
    accounts = [11, 12, 13, 14, 17, 18, 15, 16]
    accounts.each do |f|
      followed_user = User.find(f)
      user.follow(followed_user)
    end
  end

  def feed
    following_ids = self.following_users.map(&:id)
    Video.where(user_id: following_ids)
  end

  def likes_video?(video)
    video.likes.where(user: self).count > 0
  end 

  def notifications
    notifications = Activity.where(trackable_user: self.id)
  end

  def follows_user?(user)
    return false if self == user
    following_users.where("follows.followable_id = #{user.id}").count > 0
  end
end 
