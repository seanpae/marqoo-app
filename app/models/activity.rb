class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  default_scope -> { order('activities.created_at DESC') }
end
