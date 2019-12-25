module Ez
  module Resources
    class CollectionCell < ApplicationCell
      include Pagy::Frontend

      delegate :resources_name, :collection_columns, :paginator, to: :model

      def collection
        @collection ||= model.data
      end

      def header_text
        resources_name
      end

      def record_column_value(record, column)
        if column.type == :association
          column.getter.call(record)
        elsif column.type == :boolean
          maybe_use_custom_boolean_presenter(record.public_send(column.name))
        else
          record.public_send(column.name)
        end
      end

      def edit_link(record)
        return unless model.actions.include?(:edit)
        return unless can_edit?(record)

        link_to t("actions.edit"), model.path_for(action: :edit, id: record.id)
      end

      def remove_link(record)
      end

      def pagination
        if Ez::Resources.config.pagination_method
          instance_exec paginator, &Ez::Resources.config.pagination_method
        else
          pagy_nav(paginator)
        end
      end

      private

      def can_edit?(record)
        Manager::Hooks.can?(:can_edit?, model.hooks, record)
      end

      def maybe_use_custom_boolean_presenter(bool)
        return bool unless Ez::Resources.config.ui_custom_boolean_presenter

        instance_exec bool, &Ez::Resources.config.ui_custom_boolean_presenter
      end
    end
  end
end
