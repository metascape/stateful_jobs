# StatefulJobs

StatefulJobs is a Resque based library which allows you to integrate responsive background jobs in a very easy way.
StatefulJobs wraps an ActiveRecord Model around a set of jobs and adds a polling mechanism to your frontend to get your users noticed about the state of their tasks.
Very useful for:
* background jobs which provide its state to the frontend
* background jobs which need user interaction between several steps
* a set of jobs which share process information
All these jobs can either be implemented as a separate Class or inline with just a handy Proc.


## Installation

Add this line to your application's Gemfile:

```
$ gem 'stateful_jobs'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install stateful_jobs
```

Add the provided jQuery Plugin to your application.js:
```
//= require stateful_jobs
```

Or place it manually wherever your application can laod it.


## Usage

Create your Model:

```
$ rails g model import current_job:string current_state:string some:string other:string attributes:integer
```

Define your Jobs:

```ruby
class Import < ActiveRecord::Base
  include StatefulJobs::Model

  # as a proc:
  stateful_job :extract do |model|
    puts "processing #{model}..."
    # do some expensive work here...

    true | false
  end

  # or as a separate class:
  stateful_job :execute, ImportExecutionJob
end

class ImportExecutionJob < StatefulJobs::Job::Base
  def perform
    puts "processing #{@model}..."
    # do some expensive work here...

    true | false
  end
end
```

Your Model now has been equiped with following methods: ´extract!´, ´execute!´ which automatically enqueue your job on resque.
While a job is processed its state is set to 'running'. Finished job's states are set depending on their return value. A Sucessfully performed job's (return true) state becomes 'done'. If a Job returns false, its state is set to 'failed'. Errors raising an Exception result into an 'error' state.


Prepare your Controller:

```ruby
class ImportsController < ActiveRecord::Base
  include StatefulJobs::Controller

  stateful_jobs :import
end
```

This adds a ´state´ member action to your controller returning the current job/state of your Model as JSON.
Additionally each state gets his own action which is called for every state change of your job. It gets the current state passed as a ´current_state´ parameter.

Your can sum up all these state actions into one centralized callback action if you want:

```ruby
class ImportsController < ActiveRecord::Base
  include StatefulJobs::Controller

  stateful_jobs :import, action: :state_changed
end
```

`state_changed` now gets called with current_job and current_state as parameters on every state change.


Add some Routes:

```ruby
RailsApp::Application.routes.draw do

  stateful_jobs :imports

end
```

For a complete set of restful routes just use ´stateful_jobs_resources :imports´.

View:

```erb
<%= stateful_job :imports, @import, :div, class: 'spinner', interval: 3000 do %>
  spinner
<% end %>
```

Adds the followng to your html:

```html
<div class="spinner" id="import_1" data-id="1" data-current-job="current-job" data-current-state="current-state">
<script type="test/javascript">
  $('#import_1').statefulJobs({'interval': 3000})
</script>
```

The plugin now asks the server for a new state every 3 seconds. On state change the according state's action is invoked via ajax. If you want to be redirected instead of an ajax call, ajax can be disabled with `ajax: false` flag.
While a job is running, the css class `running` is applied to your spinner's div.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request