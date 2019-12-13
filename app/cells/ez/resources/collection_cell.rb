module Ez
  module Resources
    class CollectionCell < ApplicationCell
      def collection_size
        @collection_size ||= model.size
      end

      def resource_name
        @resource_name ||= options[:resource_name]
      end

      def collection_columns
        @collection_columns ||= options[:collection_columns]
      end
    end
  end
end
