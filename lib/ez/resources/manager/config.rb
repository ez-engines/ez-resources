module Ez
  module Resources
    module Manager
      class Config
        DEFAULT_ACTIONS = %i[index show new create edit update destroy].freeze

        def initialize(controller:, store:, data: nil)
          @controller = controller
          @store     = store
          @data      = data
        end

        def data
          @data ||= case controller.action_name
          when 'index'  then collection
          when 'new'    then new_resource
          when 'edit'   then resource
          when 'update' then resource
          else
            raise "Invalid action [#{controller.action_name}]"
          end
        end

        def model
          @model ||= store.model || controller_name.classify.constantize
        rescue NameError
          raise GuessingError, "Ez::Resources tried to guess model name as #{controller_name.classify} but constant is missing. You can define model class explicitly with :model options"
        end

        def actions
          @actions ||= store.actions || DEFAULT_ACTIONS
        end

        def hooks
          @hooks ||= store.hooks || []
        end

        def resource_label
          @resource_label ||= store.resource_label || :id
        end

        def resource_name
          @resource_name ||= controller_name.classify
        end

        def resources_name
          @resources_name ||= store.resources_name || resource_name.pluralize
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
          @form_fields ||= store.form_fields || collection_columns || []
        end

        def path_for(action:, id: nil)
          if id
            controller.url_for(action: action, id: id, only_path: true)
          else
            controller.url_for(action: action, only_path: true)
          end
        end

        private

        attr_reader :controller, :store

        def collection
          @collection ||= model.all
        end

        def new_resource
          @new_resource ||= model.new
        end

        def resource
          @resource ||= model.find(controller.params[:id])
        end


        def controller_name
          @controller_name ||= controller.controller_name
        end
      end
    end
  end
end
