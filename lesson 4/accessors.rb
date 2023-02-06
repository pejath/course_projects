# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history_arr_name = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history") { instance_variable_get(history_arr_name) }
      define_method("#{name}=") do |value|
        instance_variable_set(var_name, value)
        instance_variable_set(history_arr_name, []) if instance_variable_get(history_arr_name).nil?
        instance_variable_get(history_arr_name).push(value)
      end
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=") do |value|
      raise "Incorrect value type for '#{name}'" unless value.is_a? type

      instance_variable_set(var_name, value)
    end
  end
end
