module Ez
  module Resources
    class FieldCell < ApplicationCell
      def html_options
        {
          label:           model.title,
          input_html:      { value: model.default&.call },
          as:              model.type,
          collection:      model.collection,
          selected:        model.default&.call,
          include_blank:   model.required?,
          required:        model.required?,
          checked_value:   true.to_s,
          unchecked_value: false.to_s,
          wrapper:         model.wrapper,
          right_label:     model.suffix,
          input_html: {
            min: model.min
          }
        }.merge(model.options)
      end
    end
  end
end
