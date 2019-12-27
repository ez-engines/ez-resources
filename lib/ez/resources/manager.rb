require 'ez/resources/manager/dsl'
require 'ez/resources/manager/config'

module Ez
  module Resources
    module Manager
      include ::Cell::RailsExtensions::ActionController

      def self.included(base)
        base.extend(DSL)

        base.rescue_from UnavailableError do
          if Ez::Resources.config.ui_failed_hook
            instance_exec(&Ez::Resources.config.ui_failed_hook)
          else
            flash[:alert] = t('messages.unavailable', scope: Ez::Resources.config.i18n_scope)
            redirect_to '/'
          end
        end
      end

      # TODO configurabe:
      # 1. Collection method of .all or order

      def index
        Manager::Hooks.can!(:can_list?, ez_resource_config)

        ez_resource_view :collection, ez_resource_config
      end

      # TODO: Later
      def show
      end

      def new
        Manager::Hooks.can!(:can_create?, ez_resource_config)

        ez_resource_view :form, ez_resource_config
      end

      def create
        Manager::Hooks.can!(:can_create?, ez_resource_config)

        @ez_resource = ez_resource_config.model.new(ez_resource_params)

        if @ez_resource.save
          flash[:notice] = t('messages.created',
            resource_name: ez_resource_config.resource_name,
            scope:         Ez::Resources.config.i18n_scope)

          redirect_to ez_resource_config.path_for(action: :index)
        else
          flash[:alert] = t('messages.invalid',
            resource_name: ez_resource_config.resource_name,
            scope:         Ez::Resources.config.i18n_scope)

          ez_resource_view :form, ez_resource_config
        end
      end

      def edit
        Manager::Hooks.can!(:can_update?, ez_resource_config, ez_resource_config.data)

        ez_resource_view :form, ez_resource_config
      end

      def update
        Manager::Hooks.can!(:can_update?, ez_resource_config, ez_resource_config.data)

        @ez_resource = ez_resource_config.data

        if @ez_resource.update(ez_resource_params)
          flash[:notice] = t('messages.updated',
            resource_name: ez_resource_config.resource_name,
            scope:         Ez::Resources.config.i18n_scope)

          redirect_to ez_resource_config.path_for(action: :index)
        else
          flash[:alert] = t('messages.invalid',
            resource_name: ez_resource_config.resource_name,
            scope:         Ez::Resources.config.i18n_scope)

          ez_resource_view :form, ez_resource_config
        end
      end

      # TODO: Later
      def destroy
      end

      private

      def ez_resource_view(cell_name, *args)
        render html: cell("ez/resources/#{cell_name}", *args), layout: true
      end

      def ez_resource_params
        params.require(:ez_resource).permit(ez_resource_config.form_fields.map(&:name))
      end

      def ez_resource_config
        Config.new(
          controller: self,
          dsl_config: self.class.ez_resource_config_store,
          data:       @ez_resource
        )
      end
    end
  end
end
