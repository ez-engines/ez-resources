require 'ez/resources/manager/field'
require 'ez/resources/manager/config'
require 'ez/resources/manager/options'

module Ez
  module Resources
    module Manager
      include ::Cell::RailsExtensions::ActionController

      def self.included(base)
        base.extend(DSL)
      end

      module DSL
        def ez_resource_config
          @ez_resource_config || Ez::Resources::Manager::Config.new
        end

        def ez_resource(&block)
          config = Ez::Resources::Manager::Config.new
          block.call(config)
          @ez_resource_config = config
        end
      end

      # Options:
      # 1. Actions or all by default
      # 2. Collection method of .all or order

      def index
        ez_resource_view :collection, *ez_resource_config.to_attribues
      end

      # TODO: Later
      def show
      end

      def new
        ez_resource_view :form, *ez_resource_config.to_attribues
      end

      def create
        @ez_resource = ez_resource_config.model.new(ez_resource_params)

        if @ez_resource.save
          flash[:notice] = t('messages.created',
            resource_name: ez_resource_config.resource_name,
            scope:         Ez::Resources.config.i18n_scope)

          redirect_to ez_resource_config.collection_path
        else
          flash[:alert] = t('messages.invalid',
            resource_name: ez_resource_config.resource_name,
            scope:         Ez::Resources.config.i18n_scope)

          ez_resource_view :form, *ez_resource_config.to_attribues
        end
      end

      def edit
        ez_resource_view :form, *ez_resource_config.to_attribues
      end

      def update
      end

      def destroy
      end

      private

      def ez_resource_view(cell_name, *args)
        render html: cell("ez/resources/#{cell_name}", *args), layout: true
      end

      def ez_resource_params
        params.require(:ez_resource).permit(self.class.ez_resource_config.form_fields.map(&:name))
      end

      def ez_resource_config
        Options.new(
          controller: self,
          config:     self.class.ez_resource_config,
          data:       @ez_resource
        )
      end
    end
  end
end
