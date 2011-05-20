require 'yaml'
require 'erb'

class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end


class Templator
  def initialize(template, options={})
    @template = template
  end

  def fill_in(data, options={})
    save_flags options
    save_data data
    do_template
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