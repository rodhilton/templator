# Templator is a program that can take a template and a data file
# and run both through ERB in order to parse and generate output
# for the template.
#
# Author::    Rod Hilton
# Copyright:: Copyright (c) 2011 Rod Hilton
# License::   Distributes under the same terms as Ruby

require 'yaml'
require 'erb'

class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    nil
  end
end

class NilClass
  #This allows limitless dot-chaining. object.any.thing.will.be.nil
  def method_missing(name)
    nil
  end
end

# This class does most of the work for the Templator program,
# constructed with a template and capable of performing the fill_in
# work when given a data object and optional flags
class Templator
  def initialize(template)
    @template = template
  end

  def fill_in(data, flags={})
    save_flags flags
    save_data data
    do_template
  end

  # This is here to allow usage of objects that aren't actually defined in a data file inside of the template
  def method_missing(name)
    nil
  end

  private
  def save_flags(options)
    save_data_object("flags", options)
  end

  def save_data(data)
    data = ERB.new(data).result(binding)
    @ruby_obj = YAML::load(data)
    @ruby_obj.each_pair do |key, value|
      save_data_object(key, value)
    end if @ruby_obj.respond_to?(:each_pair)
  end

  def do_template
    erb_template = ERB.new @template
    erb_template.result(binding)
  end

  def save_data_object(key, value)
    metaclass.send :attr_accessor, key
    send "#{key}=".to_sym, value
  end

  def metaclass
    class << self
      self
    end
  end

end