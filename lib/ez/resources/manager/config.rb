module Ez
  module Resources
    module Manager
      class Config
        def model(value = nil)
          value ? @model = value : @model
        end

        def resource_name(value = nil)
          value ? @resource_name = value : @resource_name
        end

        def new_resource_path(value = nil)
          value ? @new_resource_path = value : @new_resource_path
        end

        def collection_columns(value = nil)
          value ? @collection_columns = value : @collection_columns
        end
      end
    end
  end
end
