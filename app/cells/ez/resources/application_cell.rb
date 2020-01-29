# frozen_string_literal: true

module Ez
  module Resources
    class ApplicationCell < Cell::ViewModel
      self.view_paths = ["#{Ez::Resources::Engine.root}/app/cells"]

      CSS_SCOPE = 'ez-resources'

      def self.form
        include ActionView::Helpers::FormHelper
        include ActionView::Helpers::DateHelper
        include ActionView::Helpers::AssetTagHelper
        include SimpleForm::ActionViewExtensions::FormHelper
        include ActionView::RecordIdentifier
        include ActionView::Helpers::FormOptionsHelper
      end

      def div_for(item, extra = nil, &block)
        content_tag :div, class: css_for(item, extra), &block
      end

      def css_for(item, extra = nil)
        scoped_item = "#{CSS_SCOPE}-#{item}"

        css_class = custom_css_map[scoped_item] || scoped_item

        extra ? "#{css_class} #{extra}" : css_class
      end

      def custom_css_map
        @custom_css_map ||= Ez::Resources.config.ui_custom_css_map || {}
      end

      def t(args)
        I18n.t(args, scope: Ez::Resources.config.i18n_scope)
      end
    end
  end
end
