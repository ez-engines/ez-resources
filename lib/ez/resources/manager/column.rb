module Ez
  module Resources
    module Manager
      class Column
        attr_reader :name, :title, :type

        def initialize(options = {})
          @name  = options.fetch(:name)
          @title = options.fetch(:title)
          @type  = options.fetch(:type)
        end
      end
    end
  end
end
