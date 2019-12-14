require 'ez/resources/manager/column'
require 'ez/resources/manager/config'
require 'ez/resources/manager/options'

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
        ez_resource_view :collection, *Options.new(controller: self, config: self.class.ez_resource_config).to_attrs
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

      def ez_resource_view(cell_name, *args)
        render html: cell("ez/resources/#{cell_name}", *args), layout: true
      end
    end
  end
end
