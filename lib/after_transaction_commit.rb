module AfterTransactionCommit
end

require "after_transaction_commit/version"
require "after_transaction_commit/database_statements"
require "after_transaction_commit/transaction"

# force autoloading if necessary
ActiveRecord::ConnectionAdapters::RealTransaction
ActiveRecord::ConnectionAdapters::Transaction.prepend(AfterTransactionCommit::Transaction)
