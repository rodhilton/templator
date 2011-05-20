require 'yaml'
require 'pp'
require 'erb'

class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end


class Templater
  def initialize(template, options={})
    @template = template
  end

  def metaclass
    class << self
      self
    end
  end

  def fill_in(document, options={})
    @flags = options
    @ruby_obj = YAML::load( document )
    @ruby_obj.each_pair do |key, value|
      metaclass.send :attr_accessor, key
      send "#{key}=".to_sym, value
    end
    erb_template = ERB.new @template
    erb_template.result(binding)
  end
end