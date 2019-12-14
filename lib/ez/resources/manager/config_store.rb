require 'ez/resources/manager/fields'
require 'ez/resources/manager/hooks'

module Ez
  module Resources
    module Manager
      class ConfigStore
        def actions(value = nil)
          value ? @actions = value : @actions
        end

        def model(value = nil)
          value ? @model = value : @model
        end

        def resource_name(value = nil)
          value ? @resource_name = value : @resource_name
        end

        def resource_label(value = nil)
          value ? @resource_label = value : @resource_label
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
            @form_fields
          end
        end

        def hooks(&block)
          if block_given?
            @hooks = Hooks.new(&block).hooks
          else
            @hooks
          end
        end
      end
    end
  end
end
