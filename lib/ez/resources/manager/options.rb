module Ez
  module Resources
    module Manager
      class Options
        def initialize(controller:, config:)
          @controller = controller
          @config     = config
        end

        def to_attrs
          [
            collection,
            {
              resource_name:      resource_name,
              new_resource_path:  ez_resource_path_for_action(:new),
              collection_columns: collection_columns
            }
        ]
        end

        private

        attr_reader :controller, :config

        def model
          @model ||= config.model || controller_name.classify.constantize
        rescue NameError
          raise GuessingError, "Ez::Resources::Manager tried to guess model name as #{controller_name.classify} but constant is missing. You can define model class explicitly with :model options"
        end

        def collection
          @collection ||= model.all
        end

        def resource_name
          @resource_name ||= controller_name.classify.pluralize
        end

        def collection_columns
          @collection_columns ||= model.columns.map do |column|
            Ez::Resources::Manager::Column.new(
              name:  column.name,
              title: column.name.humanize,
              type:  column.sql_type_metadata.type
            )
          end
        end

        def ez_resource_path_for_action(action)
          controller.url_for(action: action, only_path: true)
        end

        def controller_name
          @controller_name ||= controller.controller_name
        end
      end
    end
  end
end
