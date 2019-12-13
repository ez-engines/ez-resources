require "ez/resources/engine"
require 'ez/resources/manager'

require 'ez/configurator'
module Ez
  module Resources
    include Ez::Configurator

    # configure do |config|
    #  config.default = 'values' # can be defined here
    # end

    BaseError = Class.new(StandardError)
    GuessingError = Class.new(BaseError)
  end
end
