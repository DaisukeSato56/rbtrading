# frozen_string_literal: true

require 'bundler/setup'
require 'active_record'
require 'yaml'
require 'erb'

include ActiveRecord::Tasks

root_dir = File.dirname(__FILE__)

config_database_yml_file = File.join(root_dir, 'config', 'database.yml')
config_database_yml = YAML.safe_load(ERB.new(File.read(config_database_yml_file)).result)

DatabaseTasks.env = 'development'
DatabaseTasks.db_dir = File.join(root_dir, 'db')
DatabaseTasks.database_configuration = config_database_yml
DatabaseTasks.migrations_paths = File.join(root_dir, 'db', 'migrate')

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'
