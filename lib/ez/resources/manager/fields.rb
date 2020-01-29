require 'ez/resources/manager/action'
require 'ez/resources/manager/field'

module Ez
  module Resources
    module Manager
      class Fields
        attr_reader :fields, :actions

        def initialize(&block)
          @fields  = []
          @actions = []

          instance_eval(&block)
        end

        def field(name, options = {})
          @fields << Field.new(name: name, **options)
        end

        alias_method :column, :field

        def action(name, builder, options = {})
          @actions << Action.new(name, builder, **options)
        end
      end
    end
  end
end
