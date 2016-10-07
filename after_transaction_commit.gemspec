# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'after_transaction_commit/version'

Gem::Specification.new do |spec|
  spec.name          = "after_transaction_commit"
  spec.version       = AfterTransactionCommit::VERSION
  spec.authors       = ["Brian Palmer"]
  spec.email         = ["brianp@instructure.com"]
  spec.summary       = %q{ActiveRecord::Base.connection.after_transaction_commit { ... }}
  spec.homepage      = "https://github.com/instructure/after_transaction_commit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1"

  spec.add_dependency "activerecord", ">= 4.0"

  spec.add_development_dependency "bump"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "wwtd"
end
