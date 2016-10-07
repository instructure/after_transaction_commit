module AfterTransactionCommit
end

unless ActiveRecord::VERSION::MAJOR.between? 4, 5
  raise "Unsupported Rails version"
end

require "after_transaction_commit/version"
require "after_transaction_commit/database_statements"
require "after_transaction_commit/transaction"

# force autoloading if necessary
_ = ActiveRecord::ConnectionAdapters::RealTransaction

klass = defined?(ActiveRecord::ConnectionAdapters::OpenTransaction) ?
  ActiveRecord::ConnectionAdapters::OpenTransaction : # rails < 4.2
  ActiveRecord::ConnectionAdapters::Transaction       # rails >= 4.2

klass.prepend AfterTransactionCommit::Transaction
