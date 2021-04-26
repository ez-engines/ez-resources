# frozen_string_literal: true

module Ez
  module Resources
    module Manager
      class Action
        attr_reader :name, :builder, :options

        def initialize(name, builder, options = {})
          @name = name
          @builder = builder
          @options = options
        end
      end
    end
  end
end
