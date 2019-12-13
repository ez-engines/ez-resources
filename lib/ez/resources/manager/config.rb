module Ez
  module Resources
    module Manager
      class Config
        def model(value = nil)
          value ? @model = value : @model
        end
      end
    end
  end
end
