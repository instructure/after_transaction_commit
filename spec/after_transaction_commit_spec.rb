require 'spec_helper'

describe AfterTransactionCommit do
  it 'has a version number' do
    expect(AfterTransactionCommit::VERSION).not_to be nil
  end

  it "should execute the callback immediately if not in a transaction" do
    a = 0
    User.connection.after_transaction_commit { a += 1 }
    expect(a).to eql 1
  end

  it "should execute the callback after commit if in a transaction" do
    a = 0
    User.connection.transaction do
      User.connection.after_transaction_commit { a += 1 }
      expect(a).to eql 0
    end
    expect(a).to eql 1
  end

  it "immediately executes the callback when in a non-joinable transaction" do
    skip "Rails 5 only" if ActiveRecord.version < Gem::Version.new('5')
    a = 0
    User.connection.transaction(joinable: false) do
      User.connection.after_transaction_commit { a += 1 }
      expect(a).to eql 1
    end
    expect(a).to eql 1
  end

  it "executes the callback when a nested transaction commits within a non-joinable transaction" do
    skip "Rails 5 only" if ActiveRecord.version < Gem::Version.new('5')
    a = 0
    User.connection.transaction(joinable: false) do
      User.connection.transaction do
        User.connection.after_transaction_commit { a += 1 }
        expect(a).to eql 0
      end
      expect(a).to eql 1
    end
    expect(a).to eql 1
  end

  it "should not execute the callbacks on rollback" do
    a = 0
    User.connection.transaction do
      User.connection.after_transaction_commit { a += 1 }
      expect(a).to eql 0
      raise ActiveRecord::Rollback
    end
    expect(a).to eql 0
    User.connection.transaction do
      # verify that the callback gets cleared out, so this second transaction won't trigger it
    end
    expect(a).to eql 0
  end

  it "should avoid loops due to callbacks causing a new transaction" do
    a = 0
    User.connection.transaction do
      User.connection.after_transaction_commit { User.connection.transaction { a += 1 } }
      expect(a).to eql 0
    end
    expect(a).to eql 1
  end

  it "should execute the callback immediately if created during commit callback" do
    skip "Pre-Rails 5 only" if !ENV['REAL'] && ActiveRecord.version >= Gem::Version.new('5')
    a = 0
    User.connection.transaction do
      User.connection.after_transaction_commit { User.connection.after_transaction_commit { a += 1 } }
      expect(a).to eql 0
    end
    expect(a).to eql 1
  end

  it "should execute the callback after an inner transaction rollback" do
    a = 0
    User.connection.transaction do
      User.connection.after_transaction_commit { a += 1 }
      User.connection.transaction(:requires_new => true) { raise ActiveRecord::Rollback }
    end
    expect(a).to eql 1
  end
end
