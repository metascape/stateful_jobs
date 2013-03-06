# -*- encoding: utf-8 -*-

require File.expand_path('../lib/stateful_jobs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["metascape. / Kjell Schlitt"]
  gem.email         = ["kjell.schlitt@metascape.de"]
  gem.description   = %q{fancy gem description}
  gem.summary       = %q{fancy gem summary}
  gem.homepage      = "http://metascape"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stateful_jobs"
  gem.require_paths = ["lib"]
  gem.version       = StatefulJobs::VERSION

  gem.add_dependency 'rails'
  gem.add_dependency 'resque'

  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3-ruby'
  gem.add_development_dependency 'resque'
end