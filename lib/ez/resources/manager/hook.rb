# frozen_string_literal: true

module Ez
  module Resources
    module Manager
      class Hook
        attr_reader :name, :callback

        def initialize(name:, callback:)
          @name     = name
          @callback = callback
        end
      end
    end
  end
end
