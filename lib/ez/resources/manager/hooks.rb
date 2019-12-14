require 'ez/resources/manager/hook'

module Ez
  module Resources
    module Manager
      class Hooks
        attr_reader :hooks

        def self.can!(name, hooks = [], *args)
          return true if hooks.empty?

          return true if hooks.select { |h| h.name == name }.map { |h| h.callback.call(*args) }.all?(true)

          raise UnavailableError, "Negative #{name}"
        end

        def self.can?(name, hooks = [], *args)
          return true if hooks.empty?

          hooks.select { |h| h.name == name }.map { |h| h.callback.call(*args) }.all?(true)
        end

        def initialize(&block)
          @hooks = []

          instance_eval(&block)
        end

        def add(name, callback)
          @hooks << Hook.new(name: name, callback: callback)
        end
      end
    end
  end
end
