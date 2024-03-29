# frozen_string_literal: true

module Ez
  module Resources
    module Manager
      class Config
        include Pagy::Backend

        DEFAULT_ACTIONS = %i[index show new create edit update destroy].freeze

        attr_reader :paginator, :search, :controller

        def initialize(controller:, dsl_config:, data: nil)
          @controller = controller
          @dsl_config = dsl_config
          @data       = data
        end

        def data
          @data ||= case controller.action_name
                    when 'index'   then collection
                    when 'new'     then new_resource
                    when 'show'    then resource
                    when 'edit'    then resource
                    when 'update'  then resource
                    when 'destroy' then resource
                    else
                      raise ConfigurationError, "Invalid action #{controller.action_name}"
                    end
        end

        def total_count
          @total_count ||= model.count
        end

        def model
          @model ||= dsl_config.model || controller_name.classify.constantize
        rescue NameError
          raise GuessingError,
                "Ez::Resources tried to guess model name as #{controller_name.classify} but constant is missing. You can define model class explicitly with :model options"
        end

        def actions
          @actions ||= dsl_config.actions || DEFAULT_ACTIONS
        end

        def show_action_renders_form?
          @show_action_renders_form ||= dsl_config.show_action_renders_form
        end

        def hooks
          @hooks ||= dsl_config.hooks || []
        end

        def resource_label
          @resource_label ||= dsl_config.resource_label || :id
        end

        def resource_name
          @resource_name ||= controller_name.classify
        end

        def resources_name
          @resources_name ||= dsl_config.resources_name || resource_name.pluralize
        end

        def paginate_collection?
          @paginate_collection ||= dsl_config.paginate_collection != false
        end

        def collection_search?
          @collection_search ||= dsl_config.collection_search != false
        end

        def collection_views
          @collection_views ||= dsl_config.collection_views || []
        end

        def collection_columns
          @collection_columns ||= dsl_config.collection_columns || model.columns.map do |column|
            Ez::Resources::Manager::Field.new(
              name:  column.name,
              title: column.name.to_s.humanize,
              type:  column.sql_type_metadata.type
            )
          end.reject { |col| Ez::Resources.config.ignore_fields.include?(col.name) }
        end

        def collection_actions
          @colleciton_actions ||= dsl_config.collection_actions || []
        end

        def form_fields
          @form_fields ||= dsl_config.form_fields || collection_columns || []
        end

        def path_for(action:, id: nil, params: nil)
          if id
            controller.url_for(action: action, id: id, only_path: true)
          elsif params
            controller.url_for(action: action, **params, only_path: true)
          else
            controller.url_for(action: action, only_path: true)
          end
        end

        def params
          @params ||= controller.params
        end

        private

        attr_reader :dsl_config

        def collection
          return paginated_collection if paginate_collection?

          @collection ||= if dsl_config.collection_query
                            dsl_config.collection_query.call(model, controller)
                          else
                            model.all
                          end
        end

        def paginated_collection
          @search = model.ransack(params[:q])

          @paginated_collection ||= if dsl_config.collection_query
                                      pagy, paginated_collection = pagy dsl_config.collection_query.call(search.result,
                                                                                                         controller)
                                    else
                                      pagy, paginated_collection = pagy search.result.includes(dsl_config.includes),
                                                                        items_param: :items
                                    end
          @paginator = pagy
          paginated_collection
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
