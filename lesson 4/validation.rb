# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend CMethods
    base.include IMethods
  end

  module CMethods
    attr_accessor :validators

    def validate(attribute, type, options = nil)
      @validators ||= []
      @validators << [attribute, type, options]
    end

    def presence(attribute, _)
      "attribute can't be empty" if attribute.nil? || attribute.to_s.strip.empty?
    end

    def type(attribute, options)
      case attribute
      when Array
        'one of attributes has wrong type' unless attribute.all? { |attr| attr.is_a? options }
      else
        'attribute has wrong type' unless attribute.is_a? options
      end
    end

    def format(attribute, options)
      "'#{attribute}' has wrong format" unless attribute.match(options)
    end
  end

  module IMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      errors = []
      self.class.validators.each do |attribute, type, options|
        errors << self.class.send(type, instance_variable_get("@#{attribute}"), options)
      end
      raise errors.join(', ') if errors.any?
    end
  end
end
