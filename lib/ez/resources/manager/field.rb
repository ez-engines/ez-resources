module Ez
  module Resources
    module Manager
      class Field
        attr_reader :name, :title, :type, :required, :default, :suffix, :min, :collection, :wrapper, :options

        def initialize(options = {})
          @name       = options.delete(:name)
          @title      = options.delete(:title)      || @name.to_s.capitalize
          @type       = options.delete(:type)       || :string
          @required   = options.delete(:required)   || true
          @collection = options.delete(:collection) || []
          @default    = options.delete(:default)
          @suffix     = options.delete(:suffix)
          @min        = options.delete(:min)
          @wrapper    = options.delete(:wrapper)
          @options    = options
        end

        alias required? required
      end
    end
  end
end
