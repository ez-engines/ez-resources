require 'ez/resources/manager/field'

module Ez
  module Resources
    module Manager
      class Fields
        attr_reader :fields

        def initialize(&block)
          @fields = []

          instance_eval(&block)
        end

        def field(name, options = {})
          @fields << Field.new(name: name, **options)
        end

        alias_method :column, :field
      end
    end
  end
end
