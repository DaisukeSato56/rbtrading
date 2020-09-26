# frozen_string_literal: true

require 'active_record'
require 'active_support/time'
require 'erb'

config_dir = File.dirname(__FILE__)
config_database_yml_file = File.join(config_dir, 'database.yml')
config_database_yml = YAML.safe_load(ERB.new(File.read(config_database_yml_file)).result)

Time.zone = 'Tokyo'
ActiveRecord::Base.establish_connection(config_database_yml['development'])
ActiveRecord::Base.time_zone_aware_attributes = true

# load model files
project_root_dir = File.expand_path('..', config_dir)
model_files = File.join(project_root_dir, 'app', 'models', '**', '*.rb')
Dir.glob(model_files).map do |model_file|
  require model_file
end
