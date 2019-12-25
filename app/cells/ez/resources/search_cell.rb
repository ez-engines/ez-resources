module Ez
  module Resources
    class SearchCell < ApplicationCell
      form

      def field_label(field)
        "#{field.title} (#{t "search.suffix.#{field.search_suffix}"})"
      end
    end
  end
end
