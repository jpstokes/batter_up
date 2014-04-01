require 'active_record'
require 'logger'

load 'models/player.rb'
load 'models/statistic.rb'

ActiveRecord::Base.establish_connection :adapter  => 'sqlite3', :database => 'db/batter_up.db'

I18n.enforce_available_locales = false

ActiveSupport::LogSubscriber.colorize_logging = false
