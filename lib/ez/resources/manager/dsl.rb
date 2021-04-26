# frozen_string_literal: true

require 'ez/resources/manager/config_store'

module Ez
  module Resources
    module Manager
      module DSL
        def ez_resource_config_store
          @ez_resource_config_store || Ez::Resources::Manager::ConfigStore.new
        end

        def ez_resource(&block)
          config = Ez::Resources::Manager::ConfigStore.new
          block.call(config)

          @ez_resource_config_store = config
        end
      end
    end
  end
end
