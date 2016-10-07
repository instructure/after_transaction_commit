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
      connection = ActiveRecord::Base.connection_handler.connection_pool_list.map(&:connection).first
      connection.begin_transaction :joinable => false

      example.call

      connection.rollback_db_transaction
    end
  end
end
