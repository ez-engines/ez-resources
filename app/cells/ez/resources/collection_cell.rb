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

      def edit_link(record)
        return unless options[:actions].include?(:edit)

        link_to t("actions.edit"), "#{options[:collection_path]}/#{record.id}/edit"
      end

      def remove_link(record)
      end
    end
  end
end
