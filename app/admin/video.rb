ActiveAdmin.register Video do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :category_id, :title, :description, :thumbnail_url, :video_source, :video_file_name, :video_content_type, :video_file_size, :reported, :active
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


# form do |f|
#     f.inputs "Video Details" do
#       f.input :user_id
#       f.input :category_id
#       f.input :title
#       f.file_field :video
#       f.check_box_tag :active, :value => "active"
#     end
#     f.actions
#   end
end
