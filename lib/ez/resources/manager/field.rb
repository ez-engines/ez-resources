# frozen_string_literal: true

module Ez
  module Resources
    module Manager
      class Field
        attr_reader :name,
                    :title,
                    :type,
                    :required,
                    :default,
                    :suffix,
                    :min,
                    :collection,
                    :wrapper,
                    :options,
                    :getter,
                    :presenter,
                    :builder,
                    :searchable,
                    :sortable,
                    :search_suffix,
                    :options

        def initialize(options = {})
          @name          = options.delete(:name)
          @title         = options.delete(:title)      || @name.to_s.capitalize
          @type          = options.delete(:type)       || :string
          @required      = options.delete(:required)   || true
          @collection    = options.delete(:collection) || []
          @default       = options.delete(:default)
          @suffix        = options.delete(:suffix)
          @min           = options.delete(:min)
          @wrapper       = options.delete(:wrapper)
          @builder       = options.delete(:builder)
          @getter        = options.delete(:getter)
          @presenter     = options.delete(:presenter)
          @searchable    = options.delete(:searchable) != false
          @sortable      = options.delete(:sortable) || false
          @search_suffix = options.delete(:search_suffix) || :cont
          @options       = options # use for all other custom options
        end

        alias required? required
      end
    end
  end
end
