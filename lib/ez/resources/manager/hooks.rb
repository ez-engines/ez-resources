require 'ez/resources/manager/hook'

module Ez
  module Resources
    module Manager
      class Hooks
        attr_reader :hooks

        def self.can!(name, config, data = nil)
          return true if config.hooks.empty?
          return true if config.hooks.select { |h| h.name == name }.map { |h| h.callback.call(config.controller, data) }.all?(true)

          raise UnavailableError, "Negative #{name}"
        end

        def self.can?(name, config, data = nil)
          return true if config.hooks.empty?

          config.hooks.select { |h| h.name == name }.map { |h| h.callback.call(config.controller, data) }.all?(true)
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
