# -*- encoding: utf-8 -*-

require File.expand_path('../lib/stateful_jobs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["metascape. / Kjell Schlitt"]
  gem.email         = ["kjell.schlitt@metascape.de"]
  gem.summary       = "StatefulJobs allows you to integrate your background jobs in a very stateful and responsive way into your rails app"
  gem.homepage      = "https://github.com/metascape/stateful_jobs"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stateful_jobs"
  gem.require_paths = ["lib"]
  gem.version       = StatefulJobs::VERSION

  gem.add_dependency 'rails', '~> 3.2.0'
  gem.add_dependency 'resque', '>= 1.0.0'

  gem.add_development_dependency 'rspec-rails', '~> 2.0'
  gem.add_development_dependency 'sqlite3-ruby'

  gem.description = <<description
    StatefulJobs is a Resque based library which allows you to integrate responsive background jobs in a very easy way. StatefulJobs wraps an ActiveRecord Model around a set of jobs and adds a polling mechanism to your frontend to get your users noticed about the state of their tasks.

    Very useful for:

    * background jobs which provide its state to the frontend
    * background jobs which need user interaction between several steps
    * a set of jobs which share process information

    All these jobs can either be implemented as a separate Class or inline with just a handy Proc.
description
end
