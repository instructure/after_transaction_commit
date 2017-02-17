ActiveRecord::ConnectionAdapters::DatabaseStatements.class_eval do
  def after_transaction_commit(&block)
    if !_in_transaction_for_callbacks?
      block.call
    else
      @after_transaction_commit ||= []
      @after_transaction_commit << block
    end
  end

  private

  def _run_after_transaction_commit_callbacks
    if @after_transaction_commit.present?
      # the callback could trigger a new transaction on this connection,
      # and leaving the callbacks in @after_transaction_commit could put us in an
      # infinite loop.
      # so we store off the callbacks to a local var here.
      callbacks = @after_transaction_commit
      @after_transaction_commit = []
      callbacks.each { |cb| cb.call() }
    end
  ensure
    @after_transaction_commit = [] if @after_transaction_commit
  end

  def _remove_after_transaction_commit_callbacks
    @after_transaction_commit = [] if @after_transaction_commit
  end

  if ActiveRecord.version < Gem::Version.new('5')
    def _transaction_test_mode?
      defined?(TestAfterCommit)
    end

    def _in_transaction_for_callbacks?
      txn = _transaction_test_mode? ? _test_open_transactions : open_transactions
      txn > 0
    end

    def _test_open_transactions
      @test_open_transactions || 0
    end
  else
    def _in_transaction_for_callbacks?
      current_transaction.joinable?
    end
  end
end
