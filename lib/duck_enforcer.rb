# encoding: utf-8
require 'duck_enforcer/version'

# DuckEnforcer base class
class DuckEnforcer
  require 'forwardable'
  extend Forwardable

  def self.implement(*args)
    def_delegators :@obj, *args
    Array(args).each { |method| (@methods ||= []) << method }
  end

  def self.check_conformity!(klass)
    @methods.each do |method|
      unless klass.instance_methods.include? method
        raise(NotImplementedError, "Missing method #{method} in class #{klass}")
      end
    end
  end

  def initialize(obj)
    self.class.check_conformity! obj.class
    @obj = obj
  end
end

# Add the Class.quack_like_a! helper method
class Class
  def quacks_like_a!(klass)
    unless klass.ancestors.include? DuckEnforcer
      raise(ArgumentError, "#{klass.inspect} is not a DuckEnforcer")
    end
    klass.check_conformity!(self)
  end
end

# Add the Object#as_a helper method
class Object
  def as_a(klass)
    klass.new(self)
  end
end
