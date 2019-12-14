module Ez
  module Resources
    class FormCell < ApplicationCell
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::DateHelper
      include SimpleForm::ActionViewExtensions::FormHelper
      include ActionView::RecordIdentifier
      include ActionView::Helpers::FormOptionsHelper

      def show
        render 'show'
      end

      def form_header_label
        if model.new_record?
          "#{t('actions.new')} #{options[:resource_name].downcase}"
        else
          "#{t('actions.edit')} #{model.public_send(options[:resource_label])} #{options[:resource_name].downcase}"
        end
      end

      def submit_button_text
        if model.new_record?
          t('actions.create')
        else
          t('actions.update')
        end
      end
    end
  end
end
