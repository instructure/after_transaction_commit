_ = ActiveRecord::ConnectionAdapters::RealTransaction # force autoloading if necessary

klass = defined?(ActiveRecord::ConnectionAdapters::OpenTransaction) ?
  ActiveRecord::ConnectionAdapters::OpenTransaction : # rails < 4.2
  ActiveRecord::ConnectionAdapters::Transaction       # rails >= 4.2

klass.class_eval do
  def rollback_records_with_callbacks
    rollback_records_without_callbacks
    if self.is_a?(ActiveRecord::ConnectionAdapters::RealTransaction) ||
        (connection.send(:_transaction_test_mode?) && connection.send(:_test_open_transactions) == 0)
      connection.send(:_remove_after_transaction_commit_callbacks)
    end
  end

  def commit_records_with_callbacks
    commit_records_without_callbacks
    connection.send(:_run_after_transaction_commit_callbacks)
  end

  alias_method_chain :rollback_records, :callbacks
  alias_method_chain :commit_records, :callbacks
end
