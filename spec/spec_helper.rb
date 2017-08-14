$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require_relative "database"

require 'after_transaction_commit'
require 'byebug'
