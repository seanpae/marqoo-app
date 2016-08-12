namespace :db do

desc "Dumps the database to db/APP_NAME.dump"
task :dump => :environment do
cmd = nil
with_config do |app, host, db, user|
cmd = "pg_dump --host ec2-54-221-249-201.compute-1.amazonaws.com --username joupeicaddajqc --verbose --clean --no-owner --format=c d24p764e2dj08s > #{Rails.root}/db/#{app}.dump"
end
puts cmd
exec cmd
end

desc "Restores the database dump at db/APP_NAME.dump."
task :restore => :environment do
cmd = nil
with_config do |app, host, db, user|
cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
end
Rake::Task["db:drop"].invoke
Rake::Task["db:create"].invoke
puts cmd
exec cmd
end

desc "Dumps the database to db/APP_NAME.dump"
task :pushdump => :environment do
cmd = nil
with_config do |app, host, db, user|
cmd = "pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --format=c #{db} > #{Rails.root}/db/#{app}.dump"
end
puts cmd
exec cmd
end

desc "Restores the database dump at db/APP_NAME.dump."
task :pushrestore => :environment do
cmd = nil
with_config do |app, host, db, user|
cmd = "pg_restore --verbose --host ec2-54-221-249-201.compute-1.amazonaws.com --username joupeicaddajqc --clean --no-owner --no-acl --dbname d24p764e2dj08s #{Rails.root}/db/#{app}.dump"
end
Rake::Task["db:drop"].invoke
Rake::Task["db:create"].invoke
puts cmd
exec cmd
end

desc "Restores the database dump at db/APP_NAME.dump."
task :liverestore => :environment do
cmd = nil
with_config do |app, host, db, user|
cmd = "pg_restore --verbose --host ec2-54-209-19-197.compute-1.amazonaws.com --username postgres --clean --no-owner --no-acl --dbname marqoo_development #{Rails.root}/db/#{app}.dump"
end
Rake::Task["db:drop"].invoke
Rake::Task["db:create"].invoke
puts cmd
exec cmd
end

private

def with_config
yield Rails.application.class.parent_name.underscore,
ActiveRecord::Base.connection_config[:host],
ActiveRecord::Base.connection_config[:database],
ActiveRecord::Base.connection_config[:username]
end

end