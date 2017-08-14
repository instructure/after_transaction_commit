module AfterTransactionCommit
  module Transaction
    def after_transaction_commit(&block)
      @after_transaction_commit ||= []
      @after_transaction_commit << block
    end

    def commit_records
      super
      @after_transaction_commit.each(&:call) if @after_transaction_commit.present?
    end
  end

  module TransactionManager
    def outermost_joinable_transaction
      last_t = nil
      @stack.reverse_each do |t|
        return last_t unless t.joinable?
        last_t = t
      end
      last_t if last_t&.joinable?
    end
  end
end
