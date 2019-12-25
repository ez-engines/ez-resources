require 'ez/resources/manager/fields'
require 'ez/resources/manager/hooks'

module Ez
  module Resources
    module Manager
      class ConfigStore
        attr_accessor :actions, :model, :paginate_collection, :resource_name, :resource_label, :resources_name,
          :collection_columns, :collection_query, :collection_search

        def collection_columns(&block)
          if block_given?
            @collection_columns = Fields.new(&block).fields
          else
            @collection_columns
          end
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
