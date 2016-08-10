class Category < ActiveRecord::Base
	has_many :videos
  
	has_attached_file :thumbnail, 
     :storage => "s3",
     :s3_credentials => {
          :bucket => :marqoo,
          :access_key_id => "AKIAJFQU5UIXLKFTRCLQ",
          :secret_access_key => "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"
      },
      :url => ":s3_domain_url",
      :s3_protocol => :https,
      :path => "/:class/:attachment/:id_partition/:style/:filename",
      :styles => { :large => "600x600^" },
      :convert_options => { :large => " -gravity center -crop '600x600+0+0'"},
      :default_url => 'https://s3-us-west-2.amazonaws.com/marqoo/default.jpg'

      validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/ 

      # default_scope -> { order('categories.created_at DESC') }
end
