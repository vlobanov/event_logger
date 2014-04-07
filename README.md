# EventLogger
EventLogger is a small engine for logging events to MongoDB in Rails 4 app

[![Code Climate](https://codeclimate.com/github/vlobanov/event_logger.png)](https://codeclimate.com/github/vlobanov/event_logger)
## Status
Branch name "fetus" pretty much describes status of the gem. It is used in several private projects and works stable, however, it is not recommended for production use yet.

## Installation

Put in your Gemfile
```ruby
gem 'event_logger', github: "vlobanov/event_logger", branch: "0-0-2-fetus"

# mongoid right now has some issues with Rails 4, so use github version
gem "mongoid", github: "mongoid/mongoid", branch: "master"
```
And create `config/mongoid.yml` file ([specification](http://mongoid.org/en/mongoid/docs/installation.html))
## Simple example
Say, your app name is `CoffeeMachine`. For simple access to EventLogger, create initializer `config/initializers/event_logger.rb`
```ruby
module CoffeeMachine
  def self.event_logger
    @event_logger ||= EventLogger::Logger.new
  end
end
```
(This is somewhat using your app module as [Registry](http://martinfowler.com/eaaCatalog/registry.html))

And then anywhere in your code, when something important happens that you want to be logged

```ruby
class CoffeeController < ApplicationController
  def new_latte
    @latte = Latte.new
    
    CoffeeMachine.event_logger.log(:new_latte)
  end
end
```

Now, after each request to `new_latte` action, an event will be logged.

## Example with exceptions capturing and event messages

Just having events logged is good, but sometimes things can go wrong, so we better know about it, and more importantly, know what was happening before world ended.

EventLogger optionally takes block and executes it, saving event to Mongo after the block gets executed. If any exception was raised during execution, its class name, message and backtrace will be saved in event record, and exception <b>will be re-raised</b>.

```ruby
def new_latte_with_vodka
  CoffeeMachine.event_logger.log(:new_latte_with_vodka) do
    @latte = Latte.new
    @vodka = Vodka.new
     
    if @client.drives_car?
      fail "You better stay sober"
    end
  end
end
```

Okay, now we will be able to see that something went wrong and why client is so upset. But if situation was not so straightforward, and exception we get saved is `undefined method 'save' for nil:NilClass`, any explaining information would be welcome.

```ruby
def use_customer_recipe_to_make_coffee(recipe)
  CoffeeMachine.event_logger.log(:custom_coffee) do |event_messages|
    event_messages << "recipe: #{recipe}"
    recipe.ingredients.each do |ingredient|
      event_messages << "adding #{ingredient}"
      add!(ingredients)
    end
  end
end
```

Block that `#log` takes can take a parameter - messages container. You should not replace the object - that is, call methods like `+=`, because the object will get lost any no messages will be saved. Use `<<` method as in code sample above.

# Browsing events
EventLogger has events browsing interface. To use it you should two things - mount it in routes
```ruby
CoffeeMachine::Application.routes.draw do
  # your routes
  # ...
  mount_event_logger_at "/admin/event_logger"
end
```

And protect it so only people you want could see it:
```ruby
class ApplicationController < ActionController::Base
  #....
  before_filter :authenticate_user!
  protect_event_logger :authorizate_admin!
  
  def authorizate_admin!
    redirect_to root_path unless current_user.admin?
  end
end
```

or use block instead of method name:

```ruby
class ApplicationController < ActionController::Base
  #....
  before_filter :authenticate_user!
  
  protect_event_logger do
    redirect_to root_path unless current_user.admin?
  end
end
```

Now you can visit /admin/event_logger and see something like
<img src=http://imgur.com/5Y7nxmm.png>

#TODO
* Add filters by time
* Display exception backtrace
* Clear old logs to prevent DB from growing huge
* Custom event types
* Event descriptions

# License

event-logger is available under the MIT License. See the MIT-LICENSE file in the source distribution.