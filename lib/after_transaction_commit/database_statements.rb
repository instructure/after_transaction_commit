# this is still a class eval because it has already been included into other
# classes, so if we include into it, the other classes won't get this method
ActiveRecord::ConnectionAdapters::DatabaseStatements.class_eval do
  def after_transaction_commit(&block)
    transaction = transaction_manager.outermost_joinable_transaction
    return block.call unless transaction
    transaction.after_transaction_commit(&block)
  end
end
