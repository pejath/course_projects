module InstanceCounter
  def self.included(base)
    base.extend CMethods
    base.include IMethods
  end

  module CMethods
    attr_accessor :instances
  end

  module IMethods
    private

    def register_instance
      self.class.instances = 0 if self.class.instances.nil?
      self.class.instances += 1
    end
  end
end
