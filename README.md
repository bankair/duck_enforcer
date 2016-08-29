# DuckEnforcer

_Add a java smell to your ruby_

Working on a project with a lots of other developer ? No longer wanting to explain what a duck is meant to be able to do ? DuckEnforcer might be for you !

```ruby
class Quacker < DuckEnforcer
  implement :quack
end

class GoodDuck
  def quack() puts 'quack'; end
  quacks_like_a! Quacker # OK, all good
end

class BadDuck
  def waddle() puts 'waddle'; end
  quacks_like_a! Quacker # Raise a NotImplementedError
end
```

## Installation

Easy as pie:

```
gem install duck_enforcer
```

Or in a Gemfile:

```
gem 'duck_enforcer'
```

and finally:

```
require 'duck_enforcer'
```

## Usage

Using DuckEnforcer is a four steps process:

1. Define your interface
2. Write your implementations
3. ...
4. Profit.

### Defining an interface

Just define your interface as a class inheriting from DuckEnforcer.

Add an `implement` statement per needed method.

Exemple of an Observer interface:

```ruby
require 'duck_enforcer'

class MyObserver < DuckEnforcer
  implement :update
end
```

### Writing implementations

To (kind of) 'implement' the interface, you just have to write a class defining an instance method per 'implement' statement, and (optionally) add the `quacks_like_a!` statement:

```ruby
class LoggerObserver
  def update(value)
    puts value
  end

  quacks_like_a! MyObserver
end

class RecorderObserver
  attr_reader :values

  def update(value)
    (@values ||= []) << value
  end

  quacks_like_a! MyObserver
end
```

If you add another method to your interface, your script will fail while loading the classes that miss the new method, making it far more easy to update a duck typing based hierarchy.

### Scope restriction

In order to avoid leaking your abstrations, you can as well use the `as_a` helper, that encapsulate the callee in a DuckEnforcer wrapper, limiting access to interface methods only (plus Object instance methods).

Example:

```ruby
class ConcreteObserver
  def update(value)
    log(value)
  end

  def log(value)
    puts value
  end

  quacks_like_a! MyObserver
end

class Foobar
  def initialize(observer)
    # here, we are encapsulating observer in a DuckEnforcer wrapper
    @observer = observer.as_a MyObserver
  end

  def bar=(value)
    @observer.log('Failure') # That call will raise a NoMethodError
    @observer.update(value)  # That call will succeed
    @bar = value
  end
end
```

In the previous example, to get rid of the NoMethodError, you have to either:

* Add an `implement :log` statement in MyObserver (worst solution so far, as you are delegating two responsibilities to implementing objects: logging and update processing)
* Remove the log call, and inject a logger object in your Foobar constructor (cleaner).

Last interesting remark: an object can quack like a tons of things...

```ruby
  class Writable
    implement :write
  end

  class Readable
    implement :read
  end

  class File
    # ...
    quacks_like_a! Writable, Readable
  end
```
