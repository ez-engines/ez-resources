# frozen_string_literal: true

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
        elsif column.type == :custom
          column.builder.call(record)
        elsif column.type == :image
          url = column.getter.call(record)

          image_tag url, column.options if url
        elsif column.type == :link
          as_a_link(record, column)
        else
          record.public_send(column.name)
        end
      end

      def record_tr(record, &block)
        if model.actions.include?(:show) && Manager::Hooks.can?(:can_read?, model, record)
          content_tag :tr, class: css_for('collection-table-tr'), id: "#{resources_name.downcase}-#{record.id}", data: { link: model.path_for(action: :show, id: record.id).to_s }, &block
        else
          content_tag :tr, class: css_for('collection-table-tr'), id: "#{resources_name.downcase}-#{record.id}", &block
        end
      end

      def new_link
        return unless model.actions.include?(:new)
        return unless Manager::Hooks.can?(:can_create?, model)

        link_to t('actions.add'), model.path_for(action: :new), class: css_for('actions-new-link')
      end

      def show_link(record)
        return unless model.actions.include?(:show)
        return unless Manager::Hooks.can?(:can_read?, model, record)

        link_to t('actions.show'), model.path_for(action: :show, id: record.id), class: css_for('collection-table-td-action-item')
      end

      def as_a_link(record, column)
        return unless model.actions.include?(:show)
        return unless Manager::Hooks.can?(:can_read?, model, record)

        link_to record.public_send(column.name), model.path_for(action: :show, id: record.id)
      end

      def edit_link(record)
        return unless model.actions.include?(:edit)
        return unless Manager::Hooks.can?(:can_read?, model, record)

        link_to t('actions.edit'), model.path_for(action: :edit, id: record.id), class: css_for('collection-table-td-action-item')
      end

      def remove_link(record)
        # TODO
      end

      def pagination
        if Ez::Resources.config.pagination_method
          instance_exec paginator, &Ez::Resources.config.pagination_method
        else
          pagy_nav(paginator)
        end
      end

      private

      def maybe_use_custom_boolean_presenter(bool)
        return bool unless Ez::Resources.config.ui_custom_boolean_presenter

        instance_exec bool, &Ez::Resources.config.ui_custom_boolean_presenter
      end
    end
  end
end
