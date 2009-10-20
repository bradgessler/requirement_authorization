# Requirement Authorization Overview

Requirement authorization is a lightweight DSL designed to separate the concerns of resource access from gathering information required to access the resource.
    
A more interesting example may be to protect a paid feature from being accessed by users who did not pay for that feature:

    requirement :feature do |r|
      r.guard_unless  {|feature| current_user.account.send("#{feature}_enabled?") }
      r.resolution    {|feature| redirect_to upgrade_path(feature) }
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
  
# License

Copyright (c) 2009 Brad Gessler

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.