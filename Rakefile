# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

desc "Load the enviroment"
task :environment do
  env = ENV['SINATRA_ENV'] || ENV['RAILS_ENV']
  databases = YAML.load_file("config/database.yml")
  puts "database= #{databases[env]}"
  ActiveRecord::Base.establish_connection(databases[env])
end

Rails.application.load_tasks

task :default => :environment do
  
end

namespace :db do
  task :create => :environment do
    
  end
  
  desc "Migrate the database test"
  task :migratetest => :environment do
    env = ENV['SINATRA_ENV'] || ENV['RAILS_ENV']
    puts "Hello Thomas, running migration in #{env}!"
  end
  
  desc "Migrate the database"
  task :migrate => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end