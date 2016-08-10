ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

     columns do
       column do
         panel "Recent Videos" do
          ul do
             Video.last(5).map do |video|
               li link_to(video.title, admin_video_path(video))
             end
           end
         end
       end

       column do
       panel "Total Number of Video Comments" do
           h1 Comment.all.count
         end
       end

       column do
       panel "Total Number of Users" do
           h1 User.all.count
         end
       end

       column do
       panel "Total Number of Video Likes" do
           h1 Like.all.count
         end
       end

       column do
       panel "Total Number of Video Views" do
           h1 Impression.all.count
         end
       end

       column do
       panel "Average Number of Comments Per User" do
           comments = Comment.all.count
           users = User.all.count
           average = comments / users

           h1 average
         end
       end
     end
  end 
end
