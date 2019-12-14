module Ez
  module Resources
    class CollectionCell < ApplicationCell
      def collection_size
        @collection_size ||= model.size
      end

      def header_text
        "#{resources_name} (#{collection_size})"
      end

      def resources_name
        @resources_name ||= options[:resources_name]
      end

      def collection_columns
        @collection_columns ||= options[:collection_columns]
      end
    end
  end
end
