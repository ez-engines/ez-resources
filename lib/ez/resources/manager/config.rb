require 'ez/resources/manager/fields'

module Ez
  module Resources
    module Manager
      class Config
        DEFAULT_ACTIONS = %i[index show new create edit update destroy].freeze

        def actions(value = nil)
          value ? @actions = value : @actions || DEFAULT_ACTIONS
        end

        def model(value = nil)
          value ? @model = value : @model
        end

        def resource_name(value = nil)
          value ? @resource_name = value : @resource_name
        end

        def resource_label(value = nil)
          value ? @resource_label = value : @resource_label || :id
        end

        def resources_name(value = nil)
          value ? @resources_name = value : @resources_name
        end

        def new_resource_path(value = nil)
          value ? @new_resource_path = value : @new_resource_path
        end

        def collection_columns(value = nil)
          value ? @collection_columns = value : @collection_columns
        end

        def form_fields(&block)
          if block_given?
            @form_fields = Fields.new(&block).fields
          else
            @form_fields || []
          end
        end
      end
    end
  end
end
