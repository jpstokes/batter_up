require 'active_record'
require 'logger'

load 'models/player.rb'
load 'models/statistic.rb'
load 'lib/batter_up.rb'

environment = 'test'
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig[environment]

I18n.enforce_available_locales = false

ActiveSupport::LogSubscriber.colorize_logging = false

load 'setup.rb'

require 'factory_girl'
require_relative 'factories'

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234

  config.include FactoryGirl::Syntax::Methods
  config.order = 'random'

  # Run each test inside a DB transaction
  config.around(:each) do |test|
    ActiveRecord::Base.transaction do
      test.run
      fail ActiveRecord::Rollback
    end
  end

end
