require "ez/resources/engine"
require 'ez/resources/manager'

require 'ez/configurator'
module Ez
  module Resources
    include Ez::Configurator

    configure do |config|
      config.ignore_fields = %w[id created_at updated_at]
    end

    BaseError = Class.new(StandardError)
    GuessingError = Class.new(BaseError)
  end
end
