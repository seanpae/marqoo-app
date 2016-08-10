task :update_feed => :environment do
  puts "Updating feed..."

  # Video.get_comedy_three
  Video.get_fight_one
  Video.get_fight_two
  Video.get_comedy_feed1
  Video.get_comedy_feed2
  Video.get_comedy_feed3
  Video.get_comedy_feed4
  Video.get_comedy_feed5
  Video.get_comedy_feed6
  Video.get_comedy_feed7
  Video.get_sports_feed1
  Video.get_sports_feed2
  Video.get_sports_feed3
  Video.get_music_feed1
  Video.get_music_feed2
  Video.get_music_feed3
  Video.get_music_feed4
  Video.get_music_feed5
  Video.get_music_feed6
  Video.get_music_feed7
  Video.get_music_feed8
  Video.get_music_feed9
  Video.get_music_feed10
  Video.get_entertainment_feed1
  Video.get_entertainment_feed2
  Video.get_entertainment_feed3
  Video.get_beauty_feed1
  Video.get_beauty_feed2
  Video.get_fashion_feed1
  Video.get_fashion_feed2
  Video.get_fashion_feed3
  Video.get_new_feed1
  Video.get_new_feed2
  Video.get_new_feed3
  Video.get_faith_feed1
  Video.get_faith_feed2
  puts "done."
end