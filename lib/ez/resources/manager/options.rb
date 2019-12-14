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
            data,
            {
              resource_name:      resource_name,
              new_resource_path:  path_for_action(:new),
              collection_path:    path_for_action(:index),
              collection_columns: collection_columns,
              form_fields:        form_fields
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

        def data
          if controller.action_name == 'index'
            collection
          else
            record
          end
        end

        def collection
          @collection ||= model.all
        end

        def record
          @record ||= model.new
        end

        def resource_name
          @resource_name ||= controller_name.classify.pluralize
        end

        def collection_columns
          @collection_columns ||= model.columns.map do |column|
            Ez::Resources::Manager::Field.new(
              name:  column.name,
              title: column.name.to_s.humanize,
              type:  column.sql_type_metadata.type
            )
          end.reject { |col| Ez::Resources.config.ignore_fields.include?(col.name) }
        end

        def form_fields
          @form_fields ||= config.form_fields.presence || collection_columns
        end

        def path_for_action(action)
          controller.url_for(action: action, only_path: true)
        end

        def controller_name
          @controller_name ||= controller.controller_name
        end
      end
    end
  end
end
