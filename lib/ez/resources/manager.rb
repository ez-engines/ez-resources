require 'ez/resources/manager/column'
require 'ez/resources/manager/config'

module Ez
  module Resources
    module Manager
      include ::Cell::RailsExtensions::ActionController

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
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
      # 2. Model class or controller name to model - DONE!
      # 3. Collection method of .all
      # 4. new_resource_path
      # 5. collection_columns or all by default
      # 6. resource_attributes or all by default

      def index
        view :collection,     collection,
          resource_name:      controller_name.classify.pluralize,
          new_resource_path:  path_for_action(:new),
          collection_columns: collection_columns
      end

      def model
        @model ||= self.class.ez_resource_config.model || controller_name.classify.constantize
      rescue NameError
        raise GuessingError, "Ez::Resources::Manager tried to guess model name as #{controller_name.classify} but constant is missing. You can define model class explicitly with :model options"
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

      def collection
        @collection ||= model.all
      end

      # TODO: Later
      def show
      end

      def new
      end

      def create
      end

      def edit
      end

      def update
      end

      def destroy
      end

      private

      def view(cell_name, *args)
        render html: cell("ez/resources/#{cell_name}", *args), layout: true
      end

      def path_for_action(action)
        url_for(action: action, only_path: true)
      end
    end
  end
end
