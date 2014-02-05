# Requirement Authorization

Requirement authorization is a lightweight DSL designed to separate the concerns of resource access from gathering information required to access an action. It also lets you pass arguments into Rails before_filters for more control over what may or may not be accessed.

WARNING: This puppy isn't tested yet, but its the very next thing I plan on doing. I wanted to get this up on github first so that we could gemify this into our own project and build out tests.

## Installation

Add this line to your application's Gemfile:

    gem 'requirement_authorization'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install requirement_authorization

Then include it in your Rails application:

```ruby
class ApplicationController < ActionController::Base
  include RequirementAuthorization

  # Your requirements here..

  # Your code here...
end
```

## Examples

A more interesting example may be to protect a paid feature from being accessed by users who did not pay for that feature:

    requirement :feature do |r|
      r.guard_unless  { |feature| current_user.account.send("#{feature}_enabled?") }
      r.resolution    { |feature| redirect_to upgrade_path(feature) }
    end

In the controller just add

    class AwesomeSauceController < ActionController::Base
      feature_required :awesome_sauce
    end

A more trivial example for SSL

    requirement :ssl do |r|
      r.guard_unless  { request.ssl? }
      r.resolution    { redirect_to "https://" + request.host + request.request_uri }
    end
  
Then in the controller:

    class PaymentMethodsController << ActionController::Base
      ssl_required
    end