$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require File.expand_path '../database', __FILE__

require 'after_transaction_commit'

if ENV['REAL']
  puts 'using real transactions'
else
  puts 'using test-style transactions (use_transactional_fixtures)'
  require 'test_after_commit'
end

RSpec.configure do |config|
  unless ENV['REAL']
    config.around do |example|
      # open a transaction without using .transaction as activerecord use_transactional_fixtures does
      # code taken from https://github.com/grosser/test_after_commit/blob/master/spec/spec_helper.rb
      if ActiveRecord::VERSION::MAJOR > 3
        connection = ActiveRecord::Base.connection_handler.connection_pool_list.map(&:connection).first
        connection.begin_transaction :joinable => false
      else
        connection = ActiveRecord::Base.connection_handler.connection_pools.values.map(&:connection).first
        connection.increment_open_transactions
        connection.transaction_joinable = false
        connection.begin_db_transaction
      end

      example.call

      connection.rollback_db_transaction
      if ActiveRecord::VERSION::MAJOR == 3
        connection.decrement_open_transactions
      end
    end
  end
end
