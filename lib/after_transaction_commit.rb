module AfterTransactionCommit
end

require "after_transaction_commit/version"
require "after_transaction_commit/database_statements"

case ActiveRecord::VERSION::MAJOR
when 3
  require "after_transaction_commit/rails3"
when 4
  require "after_transaction_commit/rails4"
else
  raise "Unsupported rails version"
end
