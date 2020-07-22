# frozen_string_literal: true

module Ez
  module Resources
    class FieldCell < ApplicationCell
      def html_options
        if options[:new_record?]
          base_options.merge(
            selected:   model.default&.call,
            input_html: {
              value:   model.default&.call,
              checked: model.default&.call
            }
          )
        else
          base_options
        end
      end

      def base_options
        {
          label:           model.title,
          as:              model.type,
          collection:      model.collection,
          include_blank:   model.required?,
          required:        model.required?,
          readonly:        options[:readonly],
          checked_value:   true.to_s,
          unchecked_value: false.to_s,
          wrapper:         model.wrapper,
          right_label:     model.suffix,
          input_html:      {
            min: model.min
          }
        }.merge(model.options)
      end

      # TODO: add default value in case of new record
    end
  end
end
