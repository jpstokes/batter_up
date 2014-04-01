require 'active_record'
require 'logger'

load 'models/player.rb'
load 'models/statistic.rb'
load 'lib/batter_up.rb'

environment = 'development'
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig[environment]

I18n.enforce_available_locales = false

ActiveSupport::LogSubscriber.colorize_logging = false
ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))
