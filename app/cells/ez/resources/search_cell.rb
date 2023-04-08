# frozen_string_literal: true

module Ez
  module Resources
    class SearchCell < ApplicationCell
      SEARCHABLE_FIELDS = %i[string association select link boolean].freeze

      form

      def cast_field_type(type)
        case type
        when :link then :string
        when :boolean then :select
        when :association then :string
        else
          type
        end
      end

      def field_input_name(field)
        if association?(field)
          search_key(field.name, field.search_suffix, field.options.fetch(:association))
        else
          search_key(field.name, field.search_suffix)
        end
      end

      def field_label(field)
        field.search_label || "#{field.title} (#{t "search.suffix.#{field.search_suffix}"})"
      end

      private

      def search_key(name, search_suffix, association_prefix = nil)
        [association_prefix, name, search_suffix].compact.join('_').to_sym
      end

      def association?(field)
        field.type == :association && field.options[:association].present?
      end
    end
  end
end
