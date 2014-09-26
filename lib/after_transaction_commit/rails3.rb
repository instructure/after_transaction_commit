ActiveRecord::ConnectionAdapters::DatabaseStatements.class_eval do
  def commit_transaction_records_with_callbacks(*a)
    commit_transaction_records_without_callbacks(*a)
    _run_after_transaction_commit_callbacks
  end

  def rollback_transaction_records_with_callbacks(rollback)
    rollback_transaction_records_without_callbacks(rollback)
    if rollback || (_transaction_test_mode? && (@test_open_transactions || 0) == 0)
      _remove_after_transaction_commit_callbacks
    end
  end

  alias_method_chain :commit_transaction_records, :callbacks
  alias_method_chain :rollback_transaction_records, :callbacks
end
