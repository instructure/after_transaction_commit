# After Transaction Commit

```ruby
ActiveRecord::Base.connection.after_transaction_commit { ... }
```

[![Build Status](https://travis-ci.org/instructure/after_transaction_commit.svg?branch=master)](https://travis-ci.org/instructure/after_transaction_commit)

An ActiveRecord extension that allows writing callbacks to run after the
current transaction commits. This is similar to the built-in
ActiveRecord::Base#after_commit functionality, but more flexible, and
doesn't require putting the callback on a specific model.

Callbacks will only run *once*, on the next commit, not after every
subsequent commit. Callbacks will never run if the transaction rolls
back.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'after_transaction_commit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install after_transaction_commit

## Usage

```ruby
ActiveRecord::Base.transaction do
  ActiveRecord::Base.after_transaction_commit { run_some_background_job }
  # run_some_background_job has not run yet
end
# now, it has run

# this one runs immediately, since we are outside a transaction
ActiveRecord::Base.after_transaction_commit { some_other_task }
```

### Usage in Tests

If you want to write tests that interact with `after_transaction_commit`
callbacks, pull in the
[test_after_commit](https://github.com/grosser/test_after_commit) gem in
your test environment, and things will work as expected. See that gem's
README for installation instructions.

## Contributing

1. Fork it ( https://github.com/instructure/after_transaction_commit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
