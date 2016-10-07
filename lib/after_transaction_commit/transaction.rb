module AfterTransactionCommit
  module Transaction
    def rollback_records
      super
      if self.is_a?(ActiveRecord::ConnectionAdapters::RealTransaction) ||
        (connection.send(:_transaction_test_mode?) && connection.send(:_test_open_transactions) == 0)
        connection.send(:_remove_after_transaction_commit_callbacks)
      end
    end

    def commit_records
      super
      connection.send(:_run_after_transaction_commit_callbacks)
    end
  end
end
